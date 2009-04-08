Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbZDHJxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbZDHJxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbZDHJwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:52:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:41144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbZDHJwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:52:54 -0400
Subject: Re: [PATCH]kernel/sched_fair.c: task_new_fair() have call
 update_curr() twice
From: Peter Zijlstra <peterz@infradead.org>
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20090408021038.2D1A4F50054@mail.kolorific.com>
References: <20090408021038.2D1A4F50054@mail.kolorific.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Apr 2009 11:54:41 +0200
Message-Id: <1239184481.24828.1374.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 10:10 +0800, figo.zhang wrote:
> The task_new_fair() will call update_curr() twice, one is in
> task_new_fair(), and other one in
> enqueue_task_fair()->enqueue_entity(), they do the same,  so  it
> should be need one time.
> 
> Signed-off-by: figo.zhang <figo.zhang@kolorific.com>
> 
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 3816f21..d5913bb 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1713,7 +1713,7 @@ static void task_new_fair(struct rq *rq, struct
> task_struct *p) 
>  	sched_info_queued(p);
>  
> -	update_curr(cfs_rq);
> +
>  	place_entity(cfs_rq, se, 1);
>  
>  	/* 'curr' will be NULL if the child belongs to a different
> group */

Except that update_curr() changes ->vruntime, and place_entity() uses
->vruntime. Therefore the above is not a NOP.


