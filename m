Return-Path: <linux-kernel-owner+w=401wt.eu-S1422673AbXBURVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673AbXBURVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422717AbXBURVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:21:12 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:3150 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbXBURVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:21:11 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172077664.25076.75.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 09:19:00 -0800
Message-Id: <1172078340.8577.43.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 18:07 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 08:24 -0800, Daniel Walker wrote:
> > > The most interesting core change may be the dyntick/nohz one, where timer 
> > > ticks will only happen when needed. It's been brewing for a _loong_ time, 
> > > but it's in the standard kernel now as an option. 
> > 
> > On i386 I get the following,
> > 
> > TCP cubic registered                                                            
> > NET: Registered protocol family 1                                               
> > NET: Registered protocol family 17                                              
> > Testing NMI watchdog ... CPU#0: NMI appears to be stuck (24->24)!               
> > CPU#1: NMI appears to be stuck (0->0)!                                          
> > CPU#2: NMI appears to be stuck (0->0)!                                          
> > CPU#3: NMI appears to be stuck (0->0)!              
> > 
> > when I add nmi_watchdog=1 to my boot args which worked on prior kernels.
> > On closer inspection it looks like arch/i386/kernel/io_apic.c :
> > check_timer() --> timer_irq_works() depends on IRQ0 incrementing jiffies
> > which is no longer the case AFAIK.
> 
> At this point the PIT / HPET _is_ active and incrementing jiffies. The
> switch to local apic timers happens afterwards. 

Could be the switch over then which confuses the NMI . 

> > I'm not sure exactly how that relates to the NMI, but the check_timer()
> > function disabled the NMI through the io-apic if it can't get the
> > "timer" working through the io-apic.
> 
> Boot log please.
> 
> 	tglx
> 

.config is in there too .

ftp://source.mvista.com/pub/dwalker/tglx/

