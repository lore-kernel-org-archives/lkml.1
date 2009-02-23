Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbZBWM3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbZBWM3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZBWM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:29:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52747 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbZBWM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:29:36 -0500
Date: Mon, 23 Feb 2009 13:28:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223122832.GB31427@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl> <20090223083645.GA9582@elte.hu> <200902231229.58743.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231229.58743.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > Index: linux-2.6/arch/x86/kernel/apm_32.c
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/kernel/apm_32.c
> > > +++ linux-2.6/arch/x86/kernel/apm_32.c
> > 
> > > +
> > > +	suspend_device_irqs();
> > >  	device_power_down(PMSG_SUSPEND);
> > > +
> > > +	local_irq_disable();
> > 
> > hm, this is a very repetitive pattern, all around the various 
> > suspend/resume variants. Might make sense to make:
> > 
> >   	device_power_down(PMSG_SUSPEND);
> > 
> > do the irq line disabling plus the local irq disabling 
> > automatically. That also means it cannot be forgotten. The 
> > symmetric action should happen for PMSG_RESUME.
> > 
> > Is there ever a case where we want a different pattern?
> 
> Even if there's no such case, I prefer to call 
> local_irq_disable() explicitly in here, so that it's clearly 
> known where it happens to anyone reading this code.

That property can be implied in the function name:

   	device_power_down_irq_disable(PMSG_SUSPEND);

Open-coding it, if it looks the same in all the cases just 
increases the chances that someone somewhere copies them 
incorrectly.

	Ingo
