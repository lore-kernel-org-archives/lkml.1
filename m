Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbXHPLTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbXHPLTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXHPLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:19:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:59404 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXHPLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:19:43 -0400
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 16 Aug 2007 13:19:11 +0200
In-Reply-To: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com> (Anand Jahagirdar's message of "Thu, 16 Aug 2007 11:54:50 +0530")
Message-ID: <m3lkcbu3ps.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Anand Jahagirdar" <anandjigar@gmail.com> writes:

> +++ linux-2.6.17/kernel/fork.c
> +        /*
> +         * following code does not allow Non Root User to cross its process
> +         * limit and it alerts administrator about user Nearing the process limit.
> +         */
> + 
>        	if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur) 
>  		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> -				p->user != &root_user) 
> +				p->user != &root_user)  {
> +                        if (printk_ratelimit())
> +                                printk(KERN_WARNING "User with uid %u is Nearing the process limit\n",p->user->uid);
> +
>  			 goto bad_fork_free;

At least make that configurable - on some systems users are allowed
50 processes or so and I'm sure admins don't really want to know
which particular users are currently close to limits.

I don't really find the above useful. Perhaps we should warn when users
try to write to R/O files or execute root-only commands etc?
-- 
Krzysztof Halasa
