Return-Path: <linux-kernel-owner+w=401wt.eu-S937089AbZDIWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937089AbZDIWkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936344AbZDIWio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:38:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936887AbZDIWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:38:43 -0400
Date: Thu, 9 Apr 2009 15:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 03/13] GRU - dynamic allocation of kernel contexts
Message-Id: <20090409153709.96fb4d96.akpm@linux-foundation.org>
In-Reply-To: <20090406161011.887146000@sgi.com>
References: <20090406160809.278924000@sgi.com>
	<20090406161011.887146000@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 11:08:12 -0500
steiner@sgi.com wrote:

> @@ -803,12 +803,13 @@ again:
>  	}
>  
>  	if (!gts->ts_gru) {
> -		if (!gru_assign_gru_context(gts)) {
> +		if (!gru_assign_gru_context(gts, blade_id)) {
>  			mutex_unlock(&gts->ts_ctxlock);
>  			preempt_enable();

It's strange (but not buggy) to do the operations in this order.

	preempt_enable();
	mutex_unlock(...);

would be more natural.

>  			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */

afacit the hack doesn't do anything because the caller is still in
state TASK_RUNNING.


> +			blade_id = uv_numa_blade_id();
