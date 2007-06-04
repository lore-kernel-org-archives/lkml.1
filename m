Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXFDP2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXFDP2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXFDP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:28:44 -0400
Received: from keil-draco.com ([216.193.185.50]:50805 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXFDP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:28:43 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: Patch related with Fork Bombing Atack
Date: Mon, 4 Jun 2007 11:28:35 -0400
User-Agent: KMail/1.9.6
Cc: Anand Jahagirdar <anandjigar@gmail.com>, Nix <nix@esperi.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org, Kedar Sovani <kedar@dreamzgroup.com>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> <25ae38200706040749o1eb3b7bbs64a09e6c2e4d7331@mail.gmail.com> <Pine.LNX.4.64.0706041652130.24237@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706041652130.24237@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041128.35321.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 10:58:41 Jiri Kosina wrote:
> On Mon, 4 Jun 2007, Anand Jahagirdar wrote:
> >            I am forwarding one improved patch related with Fork Bombing
> > Attack. This patch prints a message (only once) which alerts
> > administrator/root user about fork bombing attack. I created this patch
> > to implement my idea of informing administrator about fork bombing
> > attack on his machine only once.
> >    This patch overcomes all drawbacks of my previous patch related with
> > fork bombing attack and helps administrator. added comments will
> > definitely help developers.
> >
> > +	/*
> > +	 * following code prints a message which alerts administrator/root 		 *
> > user about fork bombing Attack +	 */
> > +	if ((atomic_read(&p->user->processes) >=
> > (p->signal->rlim	[RLIMIT_NPROC].rlim_cur - 1)) &&
> > (atomic_read(&p->user->processes) <
> > p->signal->rlim[RLIMIT_NPROC].rlim_cur)) {
>
> Did this get malformed somehow? Looks like some successive lines got
> pasted together, or something.

Seeing the lack of the '+' I think it's a mangling from not paying attention 
to the 80 column marker in the editor.

> > +        	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> > p->user != &root_user) { +        		printk(KERN_CRIT"User with uid %d is
> > crossing its Process limit\n",p->user->uid); +        	}
> > +	}
>
> Why not printk_ratelimit() here? Otherwise we have looped back to the
> possibility of user flooding the system logs, which has been already
> discussed in this thread, right?
>
> Also the { and } braces seem redundant.
They are. 

Here's two hints:
1) double check for hidden "word wrap" problems. A sane programmers editor 
will alert you to this, and careful checking of the patches before posting 
will also reveal them. (emacs shows a \ in the 80th column, jed puts a $ 
there, etc...)
2) when there is a potential for syslog spam - like your patch has - use 
printk_ratelimit() instead of printk(). This will throttle the output so that 
flooding the syslog is no longer possible.

DRH
ps: you patch is very difficult to apply - try using git
