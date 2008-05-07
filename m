Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbYEGPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbYEGPuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYEGPu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:50:28 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:28251 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755988AbYEGPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:50:26 -0400
X-YMail-OSG: tKtxZ.oVM1kYzYNImgSgU33RvI4Yl7Fc.5qh.JfzAUl37vS6tzdkfsTAvpNHLJPLb4oo4f0Rbv7dl1TImG7M25sv4RbqJLXA.jDkEUoZt_1prYyeMeeqf17yXarfSxhq.WxiEB3iRC0jkqQ-
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Wed, 7 May 2008 08:50:25 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <530038.77501.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Wednesday, May 7, 2008 5:02:23 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> ----- Original Message ----
> 
> > From: Bart Van Assche 
> > To: Martin Knoblauch 
> > Cc: linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> > Sent: Wednesday, May 7, 2008 3:06:02 PM
> > Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 
> 2.6.24)
> > 
> > On Wed, May 7, 2008 at 2:42 PM, Martin Knoblauch wrote:
> > >
> > >  any news on the one below? I upgraded to 2.6.25.2 and the problem still 
> > persists. Would adding a bugzilla actually help ? :-)
> > >
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/1144.html
> > 
> > I noticed a similar issue on 2.6.22 and 2.6.24 kernels: with ACPI
> > disabled Linux' clock jumps backward and forward early during boot.
> > See also the kernel messages from the attachment in comment #13 of
> > http://bugzilla.kernel.org/show_bug.cgi?id=9936.
> > 
> > Bart,
> 
> Hi Bart,
> 
> no this looks different. As soon as the timesource is detected, I see non-zero 
> timestamps
> in dmesg, but they look smaller and jump in both directions. And I have never 
> seen this before
> 2.6.25.
> 
> It actually might be a good idea to get the dmesg output from 2.6.24.
> 
> Cheers
> Martin

 interesting - maybe related to clocksources. The HPET seems to be detected later in 2.6.25:

2.6.24:

[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
-->[    0.000000] hpet clockevent registered
-->[    0.000000] TSC calibrated against HPET
[  150.233392] time.c: Detected 2327.502 MHz processor.
[  150.235525] Console: colour VGA+ 80x25
[  150.235532] console [tty0] enabled
[  150.235546] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[  150.235548] ... MAX_LOCKDEP_SUBCLASSES:    8
[  150.235549] ... MAX_LOCK_DEPTH:          30
[  150.235550] ... MAX_LOCKDEP_KEYS:        2048
[  150.235551] ... CLASSHASH_SIZE:           1024
[  150.235552] ... MAX_LOCKDEP_ENTRIES:     8192
[  150.235553] ... MAX_LOCKDEP_CHAINS:      16384
[  150.235554] ... CHAINHASH_SIZE:          8192
[  150.235556]  memory used by lock dependency info: 1712 kB
[  150.235557]  per task-struct memory footprint: 2160 bytes
[  150.235559] Checking aperture...
[  150.235568] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[  150.267666] Placing software IO TLB between 0x123c000 - 0x523c000
[  150.377395] Memory: 8086092k/9437184k available (2901k kernel code, 301896k reserved, 1534k data, 772k init)
[  150.454897] Calibrating delay using timer specific routine.. 4659.71 BogoMIPS (lpj=9319423)


2.6.25.2:

[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
-->[    0.000000] TSC calibrated against PM_TIMER
[    0.000004] time.c: Detected 2327.497 MHz processor.
[    0.002079] Console: colour VGA+ 80x25
[    0.002086] console [tty0] enabled
[    0.002107] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.002109] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.002110] ... MAX_LOCK_DEPTH:          48
[    0.002111] ... MAX_LOCKDEP_KEYS:        2048
[    0.002112] ... CLASSHASH_SIZE:           1024
[    0.002114] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.002115] ... MAX_LOCKDEP_CHAINS:      16384
[    0.002116] ... CHAINHASH_SIZE:          8192
[    0.002117]  memory used by lock dependency info: 1712 kB
[    0.002119]  per task-struct memory footprint: 3456 bytes
[    0.002121] Checking aperture...
[    0.002130] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x15093000 - 0x19093000
[    0.004000] Memory: 8110236k/9437184k available (2950k kernel code, 277752k reserved, 1567k data, 800k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
-->[    0.004000] hpet clockevent registered
[    0.080008] Calibrating delay using timer specific routine.. 4660.31 BogoMIPS (lpj=9320632)


 Any ideas how to force hpet earlier? Specifying hpet=force and/or clocksource=hpet did not help.

Cheers
Martin
