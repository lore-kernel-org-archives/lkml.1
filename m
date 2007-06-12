Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXFLRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXFLRc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXFLRcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:32:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:9575 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbXFLRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:32:21 -0400
Date: Tue, 12 Jun 2007 19:32:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roland Dreier <rdreier@cisco.com>
cc: Anand Jahagirdar <anandjigar@gmail.com>, linux-kernel@vger.kernel.org,
       security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       akpm@digeo.com, Daniel Hazelton <dhazelton@enter.net>,
       Jens Axboe <jens.axboe@oracle.com>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: Patch related with Fork Bobmbing Attack
In-Reply-To: <adalkep85pq.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0706121931390.19578@fbirervta.pbzchgretzou.qr>
References: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com>
 <adalkep85pq.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12 2007 10:04, Roland Dreier wrote:
> > +	/*
> > +         * following code does not allow Non Root User to cross its process
> > +         * limit. it alerts administrator about fork bombing attack and prevents
> > +         * it.
> > +         */
> >  	if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur) 
> >  		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> > -				p->user != &root_user) 
> > -	
> > +				p->user != &root_user) {
> > +			if (printk_ratelimit())
> > +                                printk(KERN_CRIT"User with uid %d is crossing its process limit\n",p->user->uid);
> >  			goto bad_fork_free;
> > +		}
>
>please run scripts/checkpatch.pl against your patch.  It will point
>out numerous problems with the coding style.  Also, I think a space
>between KERN_CRIT and " would look better too.

And uid is %lu, not %d.
And s/its/his/ or s/its/the/;

	Jan
-- 
