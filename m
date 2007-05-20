Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbXETCOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbXETCOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 22:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbXETCOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 22:14:25 -0400
Received: from userg500.nifty.com ([202.248.238.80]:16777 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbXETCOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 22:14:24 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	b=pctTpHnmv6Ry09IXTg7tDrnbLdE03tcpLSSieFNvKEW90ijWhGPLzLYVNE2Wcwmxx
	kAvPZoCcoiVyZ4bbIAcFA==
Date: Sun, 20 May 2007 11:14:09 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [SMP BUG]  [clockevents: i386 drivers patch]  introduces 
 irqbalance-does-not-work-properly problem
Message-Id: <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
In-Reply-To: <20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
References: <1178202559.3767.21.camel@localhost.localdomain>
	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	<1178463619.3793.14.camel@localhost.localdomain>
	<1178777214.2951.18.camel@ymzhang>
	<20070510160615.6aa9cef6.akpm@linux-foundation.org>
	<20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


[clockevents: i386 drivers patch] introduces
  irqbalance-does-not-work-properly problem.

 
(The irq is not distributed to two Core
  ,most of the irq is distributed to CPU1)
 

 Mr. Thomas Gleixner,
 any idea to fix this problem?


>e9e2cdb412412326c4827fc78ba27f410d837e6e is first bad commit
>commit e9e2cdb412412326c4827fc78ba27f410d837e6e
>Author: Thomas Gleixner <tglx@linutronix.de>
>Date:   Fri Feb 16 01:28:04 2007 -0800
>
>    [PATCH] clockevents: i386 drivers
>    
>    Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
>    the timer IRQ to call into the PIT/HPET driver's event handler and the
>    lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
>    timer functionality is delegated to the core framework code and replaces the
>    compile and runtime evalution in do_timer_interrupt_hook()
>    
>    Use the clockevents broadcast support and implement the lapic_broadcast
>    function for ACPI.
>    
>    No changes to existing functionality.
>    
>    [ kdump fix from Vivek Goyal <vgoyal@in.ibm.com> ]
>    [ fixes based on review feedback from Arjan van de Ven <arjan@infradead.org> ]
>    Cleanups-from: Adrian Bunk <bunk@stusta.de>
>    Build-fixes-from: Andrew Morton <akpm@osdl.org>
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>    Cc: john stultz <johnstul@us.ibm.com>
>    Cc: Roman Zippel <zippel@linux-m68k.org>
>    Cc: Andi Kleen <ak@suse.de>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>


Best Regards
Komuro


> Hi,
> 
> The irqbalance does not work properly with kernel 2.6.21
> on DualCore processor(AMD Athlon64 X2)
> 
> (The irq is not distributed to two Core
>  ,most of the irq is distributed to CPU1)
> 
> Kernel 2.6.20 does not have this problem.
> 
> The irqbalance version is 1.13-4.fc6.
> 
> Any idea to fix this problem?
> 
>            CPU0       CPU1       
>   0:         85          0   IO-APIC-edge      timer
>   1:          0        698   IO-APIC-edge      i8042
>   6:          0          5   IO-APIC-edge      floppy
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          0        114   IO-APIC-edge      i8042
>  14:        369       2281   IO-APIC-edge      ide0
>  15:          0         24   IO-APIC-edge      ide1
>  16:         15      38239   IO-APIC-fasteoi   yenta, pcnet_cs
>  17:          0          0   IO-APIC-fasteoi   yenta
> NMI:          0          0 
> LOC:      50548      50547 
> ERR:          0
> MIS:      15503
> 
> 
> Best Regards
> Komuro
