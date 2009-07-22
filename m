Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZGVOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZGVOa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZGVOa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:30:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZGVOa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:30:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dsaxena@plexity.net
Subject: Re: [linux-pm] x86: Expected system state when resumed
Date: Wed, 22 Jul 2009 16:30:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>
References: <20090721164542.GA30390@plexity.net> <200907212248.18050.rjw@sisk.pl> <20090722141710.GA17721@plexity.net>
In-Reply-To: <20090722141710.GA17721@plexity.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221630.50154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Deepak Saxena wrote:
> On Jul 21 2009, at 22:48, Rafael J. Wysocki was caught saying:
> > On Tuesday 21 July 2009, Deepak Saxena wrote:
> > > 
> > > I am working on getting suspend/resume working on an x86 system
> > > (OLPC XO-1.5) where we are implementing ACPI based suspend/resume
> > > using Open Firmware and what I am seeing right now is that on 
> > > resume, we're not receiving interrupts so the system locks
> > > up in the suspend path when msleep() is called from the EHCI
> > > HCD resume code. lapic_resume() is being called so the APIC
> > > is being restored.  I'm looking for information on what else
> > > Linux's expectation from the firmware when control is handed back 
> > > before I start dumping every system register pre and post resume.
> > 
> > If that's 2.6.30 or later and your timer interrupt is MSI, for example, please
> > check if the timer interrupt is marked as IRQF_TIMER.  If it's not,
> > suspend_device_irqs() will mark it as disabled and it won't work during
> > early resume.
> 
> Thanks. I am using 2.6.30.1 and the standard x86 HPET driver which has 
> IRQF_TIMER set so this is not the issue. I've determined that if I boot 
> with "noapic", I can suspend/resume, but the system runs very slow as the
> PATA controller is now polled instead of irq driven.

So it looks like with IO-APIC enabled the timer interrupts don't reach the CPU
during resume, which indicates that the post-resume status of the IO-APIC is
somewhat not as expected.

Best,
Rafael
