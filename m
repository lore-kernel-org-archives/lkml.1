Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbXFDO7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbXFDO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXFDO7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:59:43 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39484 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXFDO7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:59:42 -0400
Date: Mon, 4 Jun 2007 16:58:41 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Anand Jahagirdar <anandjigar@gmail.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Nix <nix@esperi.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org, Kedar Sovani <kedar@dreamzgroup.com>
Subject: Re: Patch related with Fork Bombing Atack
In-Reply-To: <25ae38200706040749o1eb3b7bbs64a09e6c2e4d7331@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706041652130.24237@twin.jikos.cz>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> 
 <20070601073020.GL32105@kernel.dk> <87odjw8wxq.fsf@hades.wkstn.nix> 
 <200706032129.29088.dhazelton@enter.net> <25ae38200706040749o1eb3b7bbs64a09e6c2e4d7331@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Anand Jahagirdar wrote:

>            I am forwarding one improved patch related with Fork Bombing 
> Attack. This patch prints a message (only once) which alerts 
> administrator/root user about fork bombing attack. I created this patch 
> to implement my idea of informing administrator about fork bombing 
> attack on his machine only once.
>    This patch overcomes all drawbacks of my previous patch related with 
> fork bombing attack and helps administrator. added comments will 
> definitely help developers.

> +	/*
> +	 * following code prints a message which alerts administrator/root 		 * user about fork bombing Attack
> +	 */
> +	if ((atomic_read(&p->user->processes) >= (p->signal->rlim	[RLIMIT_NPROC].rlim_cur - 1)) && (atomic_read(&p->user->processes) < p->signal->rlim[RLIMIT_NPROC].rlim_cur)) {

Did this get malformed somehow? Looks like some successive lines got 
pasted together, or something.

> +        	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) && p->user != &root_user) {
> +        		printk(KERN_CRIT"User with uid %d is crossing its Process limit\n",p->user->uid);
> +        	}
> +	}

Why not printk_ratelimit() here? Otherwise we have looped back to the 
possibility of user flooding the system logs, which has been already 
discussed in this thread, right? 

Also the { and } braces seem redundant.

Thanks,

-- 
Jiri Kosina
