Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXFLRE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXFLRE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXFLREU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:04:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31256 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXFLREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:04:20 -0400
X-IronPort-AV: i="4.16,412,1175497200"; 
   d="scan'208"; a="163299656:sNHT43917345"
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, akpm@digeo.com,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Jens Axboe" <jens.axboe@oracle.com>, "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Patch related with Fork Bobmbing Attack
X-Message-Flag: Warning: May contain useful information
References: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Jun 2007 10:04:17 -0700
In-Reply-To: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com> (Anand Jahagirdar's message of "Tue, 12 Jun 2007 22:19:49 +0530")
Message-ID: <adalkep85pq.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2007 17:04:17.0728 (UTC) FILETIME=[B6449400:01C7AD13]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	/*
 > +         * following code does not allow Non Root User to cross its process
 > +         * limit. it alerts administrator about fork bombing attack and prevents
 > +         * it.
 > +         */
 >  	if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur) 
 >  		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 > -				p->user != &root_user) 
 > -	
 > +				p->user != &root_user) {
 > +			if (printk_ratelimit())
 > +                                printk(KERN_CRIT"User with uid %d is crossing its process limit\n",p->user->uid);
 >  			goto bad_fork_free;
 > +		}

please run scripts/checkpatch.pl against your patch.  It will point
out numerous problems with the coding style.  Also, I think a space
between KERN_CRIT and " would look better too.

 - R.
