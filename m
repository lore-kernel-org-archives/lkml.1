Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZKYWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZKYWIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZKYWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:08:31 -0500
Received: from www.tglx.de ([62.245.132.106]:51302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970AbZKYWIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:08:31 -0500
Date: Wed, 25 Nov 2009 23:07:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: correct a few numbers in comments and printk
 outputs
In-Reply-To: <20091125131802.e8044b9a.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0911252304480.24119@localhost.localdomain>
References: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091123152516.729e1407.akpm@linux-foundation.org> <20091124101403.GA25364@pengutronix.de> <20091125115601.3741fcc7.akpm@linux-foundation.org> <alpine.LFD.2.00.0911252116240.24119@localhost.localdomain>
 <20091125131802.e8044b9a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Andrew Morton wrote:
> On Wed, 25 Nov 2009 21:18:39 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > > @@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_
> > > > >  				dev->min_delta_ns += dev->min_delta_ns >> 1;
> > > > >  
> > > > >  			printk(KERN_WARNING
> > > > > -			       "CE: %s increasing min_delta_ns to %lu nsec\n",
> > > > > +			       "CE: %s increasing min_delta_ns to %llu nsec\n",
> > > > >  			       dev->name ? dev->name : "?",
> > > > > -			       dev->min_delta_ns << 1);
> > > > > +			       (unsigned long long) dev->min_delta_ns << 1);
> > > > '<< 1' is wrong here, too.
> > > > 
> > > 
> > > What's wrong with it?  That leftshift appears to be to compensate for
> > > the rightshift a few lines above.
> > > 
> > > That change was unobvious and unchangelogged, so here we are again.
> > 
> > That's actually my fault. In commit 61c22c34 I removed the WARN_ON
> > which we put there to gather data on kerneloops.org for a while and
> > did not fix the printk format string.
> > 
> 
> The issue is not the format string.  I'm wondering why Uwe removed that
> left-shift of dev->min_delta_ns.

Sorry, I'm confused: I did not fix the argument. The printk was
actually before the code which adjusted the min_delta_ns in the old
WARN_ON case. When I removed the WARN_ON I moved the printk down and
kept the << 1 which is crap. We want to print the new value not the
double of it.

Thanks,

	tglx
