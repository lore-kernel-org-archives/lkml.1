Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXJBLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXJBLPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXJBLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:15:45 -0400
Received: from namei.org ([69.55.235.186]:47380 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752775AbXJBLPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:15:44 -0400
Date: Tue, 2 Oct 2007 04:15:29 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
In-Reply-To: <4701F419.8080103@nttdata.co.jp>
Message-ID: <Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
References: <4701F285.5000206@nttdata.co.jp> <4701F419.8080103@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Kentaro Takeda wrote:

> +
> +	mb(); /* Instead of using spinlock. */
> +	ptr = domain_initializer_list;
> +	if (ptr) {
> +		while (ptr->next)
> +			ptr = ptr->next;
> +		ptr->next = new_entry;
> +	} else
> +		domain_initializer_list = new_entry;
> +

Please use standard kernel list handling, per include/linux/list.h

Why do you need to avoid spinlocks for these manipulations?



- James
-- 
James Morris
<jmorris@namei.org>
