Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXBURCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXBURCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422692AbXBURCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:02:40 -0500
Received: from www.osadl.org ([213.239.205.134]:43620 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422689AbXBURCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:02:39 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172075053.8577.38.camel@imap.mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 18:07:44 +0100
Message-Id: <1172077664.25076.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 08:24 -0800, Daniel Walker wrote:
> > The most interesting core change may be the dyntick/nohz one, where timer 
> > ticks will only happen when needed. It's been brewing for a _loong_ time, 
> > but it's in the standard kernel now as an option. 
> 
> On i386 I get the following,
> 
> TCP cubic registered                                                            
> NET: Registered protocol family 1                                               
> NET: Registered protocol family 17                                              
> Testing NMI watchdog ... CPU#0: NMI appears to be stuck (24->24)!               
> CPU#1: NMI appears to be stuck (0->0)!                                          
> CPU#2: NMI appears to be stuck (0->0)!                                          
> CPU#3: NMI appears to be stuck (0->0)!              
> 
> when I add nmi_watchdog=1 to my boot args which worked on prior kernels.
> On closer inspection it looks like arch/i386/kernel/io_apic.c :
> check_timer() --> timer_irq_works() depends on IRQ0 incrementing jiffies
> which is no longer the case AFAIK.

At this point the PIT / HPET _is_ active and incrementing jiffies. The
switch to local apic timers happens afterwards. 

> I'm not sure exactly how that relates to the NMI, but the check_timer()
> function disabled the NMI through the io-apic if it can't get the
> "timer" working through the io-apic.

Boot log please.

	tglx


