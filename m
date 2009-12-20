Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZLTTPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZLTTPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZLTTPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:15:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42703 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbZLTTPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:15:51 -0500
Date: Sun, 20 Dec 2009 20:15:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091220191531.GA17878@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
 <1261335300.30458.209.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261335300.30458.209.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Sun, 2009-12-20 at 18:06 +0000, tip-bot for Peter Zijlstra wrote:
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 720df10..7ffde2a 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -7828,44 +7828,48 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
> >  	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
> >  
> >  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> > -		pr_cont("does not load-balance\n");
> > +		printk("does not load-balance\n");
> >  		if (sd->parent)
> > -			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n");
> > +			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
> > +					" has parent");
> 
> Missing a trailing \n.

It's also needlessly broken mid-string. Checkpatch should warn about printk 
lines that end with a '"', those are almost always a sign of some ill-advised 
break-the-string artifact.

	Ingo
