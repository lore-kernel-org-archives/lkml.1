Return-Path: <linux-kernel-owner+w=401wt.eu-S1764200AbXETKsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764200AbXETKsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXETKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:48:28 -0400
Received: from userg503.nifty.com ([202.248.238.83]:39070 "EHLO
	userg503.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbXETKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:48:27 -0400
DomainKey-Signature: a=rsa-sha1; s=userg503; d=nifty.com; c=nofws; q=dns;
	b=Wy5tBwZh8DJUMuPD9o4L9Yp14VTK6FI/BKGfn7Kx9HWcAExORrOm4LgHGKPx57YUP
	E55+iNTrMGyWJS2n2xMuw==
Date: Sun, 20 May 2007 19:48:01 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [SMP BUG]  [clockevents: i386 drivers patch]  introduces 
 irqbalance-does-not-work-properly problem
Message-Id: <20070520194801.6436597c.komurojun-mbn@nifty.com>
In-Reply-To: <1179644956.21827.5.camel@chaos>
References: <1178202559.3767.21.camel@localhost.localdomain>
	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	<1178463619.3793.14.camel@localhost.localdomain>
	<1178777214.2951.18.camel@ymzhang>
	<20070510160615.6aa9cef6.akpm@linux-foundation.org>
	<20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
	<20070520111409.1793a2f6.komurojun-mbn@nifty.com>
	<1179644956.21827.5.camel@chaos>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 09:09:16 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:


> > Mr. Thomas Gleixner,
> >  any idea to fix this problem?
> 
> Which problem ?

The problem is CPU1 receives 38239 interrupt-16
but CPU0 receives only 15 interrupt-16
CPU0 should receive more interrupts.

           CPU0       CPU1       
  0:         85          0   IO-APIC-edge      timer
  1:          0        698   IO-APIC-edge      i8042
  6:          0          5   IO-APIC-edge      floppy
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0        114   IO-APIC-edge      i8042
 14:        369       2281   IO-APIC-edge      ide0
 15:          0         24   IO-APIC-edge      ide1
 16:         15      38239   IO-APIC-fasteoi   yenta, pcnet_cs   <<< problem
 17:          0          0   IO-APIC-fasteoi   yenta
NMI:          0          0 
LOC:      50548      50547 
ERR:          0
MIS:      15503


Best Regards
Komuro

> On Sun, 2007-05-20 at 11:14 +0900, Komuro wrote:
> > Hi,
> > 
> > 
> > [clockevents: i386 drivers patch] introduces
> >   irqbalance-does-not-work-properly problem.
> 
> it disables irq balancing for IRQ0, but this does not affect any other
> interrupts. It is almost irrelevant as the PIT/HPET timer interrupt
> (irq0) is disabled anyway and the local apic timer is used.
> 
> > >            CPU0       CPU1       
> > >   0:         85          0   IO-APIC-edge      timer
> 
> There is no interrupt happening after bootup, so balancing is not a
> problem here.
> 
> > Mr. Thomas Gleixner,
> >  any idea to fix this problem?
> 
> Which problem ?
> 
> 	tglx
> 
> 
