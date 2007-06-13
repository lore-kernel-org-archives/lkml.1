Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXFMOo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXFMOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbXFMOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:44:49 -0400
Received: from keil-draco.com ([216.193.185.50]:50480 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbXFMOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:44:49 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: Patch related with Fork Bobmbing Attack
Date: Wed, 13 Jun 2007 10:44:41 -0400
User-Agent: KMail/1.9.6
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Anand Jahagirdar" <anandjigar@gmail.com>, linux-kernel@vger.kernel.org,
       security@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       akpm@digeo.com, "Jens Axboe" <jens.axboe@oracle.com>,
       "Jiri Kosina" <jikos@jikos.cz>
References: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com> <Pine.LNX.4.64.0706121931390.19578@fbirervta.pbzchgretzou.qr> <38425.simon.1181734449@5ec7c279.invalid>
In-Reply-To: <38425.simon.1181734449@5ec7c279.invalid>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131044.42338.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 07:34:09 Simon Arlott wrote:
> On Tue, June 12, 2007 18:32, Jan Engelhardt wrote:
> > On Jun 12 2007 10:04, Roland Dreier wrote:
> >> > +	/*
> >> > +         * following code does not allow Non Root User to cross its
> >> > process +         * limit. it alerts administrator about fork bombing
> >> > attack and prevents +         * it.
> >> > +         */
> >> >  	if (atomic_read(&p->user->processes) >=
> >> > p->signal->rlim[RLIMIT_NPROC].rlim_cur) if (!capable(CAP_SYS_ADMIN) &&
> >> > !capable(CAP_SYS_RESOURCE) && -				p->user != &root_user)
> >> > -
> >> > +				p->user != &root_user) {
> >> > +			if (printk_ratelimit())
> >> > +                                printk(KERN_CRIT"User with uid %d is
> >> > crossing its process
> >>
> >> limit\n",p->user->uid);
> >>
> >> >  			goto bad_fork_free;
> >> > +		}
>
> Why does this need to be KERN_CRIT? You can't assume that every time a
> process limit is reached that it's a fork bomb.


I think the reasoning here is to alert the administrator(s) to the possibility 
that somebody has just tried a fork-bomb. A better test, IMHO, would be to 
check how fast the processes are being spawned and whether a large percentage 
share the same parent. (Those two taken together would better spot most 
fork-bombs, including the very simple types that are just a simple one-liner)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
