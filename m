Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZBWOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZBWOss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZBWOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:48:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZBWOsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:48:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 15:48:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902231229.58743.rjw@sisk.pl> <20090223122832.GB31427@elte.hu>
In-Reply-To: <20090223122832.GB31427@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231548.12821.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > Index: linux-2.6/arch/x86/kernel/apm_32.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/arch/x86/kernel/apm_32.c
> > > > +++ linux-2.6/arch/x86/kernel/apm_32.c
> > > 
> > > > +
> > > > +	suspend_device_irqs();
> > > >  	device_power_down(PMSG_SUSPEND);
> > > > +
> > > > +	local_irq_disable();
> > > 
> > > hm, this is a very repetitive pattern, all around the various 
> > > suspend/resume variants. Might make sense to make:
> > > 
> > >   	device_power_down(PMSG_SUSPEND);
> > > 
> > > do the irq line disabling plus the local irq disabling 
> > > automatically. That also means it cannot be forgotten. The 
> > > symmetric action should happen for PMSG_RESUME.
> > > 
> > > Is there ever a case where we want a different pattern?
> > 
> > Even if there's no such case, I prefer to call 
> > local_irq_disable() explicitly in here, so that it's clearly 
> > known where it happens to anyone reading this code.
> 
> That property can be implied in the function name:
> 
>    	device_power_down_irq_disable(PMSG_SUSPEND);
> 
> Open-coding it, if it looks the same in all the cases just 
> increases the chances that someone somewhere copies them 
> incorrectly.

Well, I see your point, but in that case I'd rather couple the disabling of
local interrupts on the CPU with sysdev_suspend and the disabling (or whatever
Eric would like to call that) of device interrupts with device_power_down().

Thanks,
Rafael
