Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbXCLA74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbXCLA74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXCLA74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:59:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbXCLA7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:59:55 -0400
Date: Sun, 11 Mar 2007 17:59:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Rolland <rol@as2917.net>
cc: "'Tejun Heo'" <htejun@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       Alan Cox <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
In-Reply-To: <019c01c7642c$1ca4f5e0$2101a8c0@donald>
Message-ID: <Pine.LNX.4.64.0703111750010.9690@woody.linux-foundation.org>
References: <019c01c7642c$1ca4f5e0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Mar 2007, Paul Rolland wrote:
>
> My machine is having two problems : the one you are describing above,
> which is due to a SIL controler being connected to one port of the ICH7
> (at least, it seems to), and probing it goes  timeout, but nothing is
> connected on it.

Ok, so that's just a message irritation, not actually bothersome 
otherwise?

> The second problem is a Jmicron363 controler that is failing to detect
> the DVD-RW that is connected, unless I use the irqpoll option as Tejun has
> suggested.

.. and this one has never worked without irqpoll?

> But, as you suggest it, I'm adding pci=nomsi to the command line....
> rebooting... no change for this part of the problem.
> 
> OK, the /proc/interrupt for this config, and the dmesg attached.
> 
> 3 [23:22] rol@riri:~> cat /proc/interrupts 
>            CPU0       CPU1       
>   0:     297549          0   IO-APIC-edge      timer
>   1:          7          0   IO-APIC-edge      i8042
>   4:         13          0   IO-APIC-edge      serial
>   6:          5          0   IO-APIC-edge      floppy
>   8:          1          0   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:        126          0   IO-APIC-edge      i8042
>  14:       8313          0   IO-APIC-edge      libata
>  15:          0          0   IO-APIC-edge      libata
>  16:          0          0   IO-APIC-fasteoi   eth1, libata

So it's the irq16 one that is the Jmicron controller and just isn't 
getting any interrupts?

Since all the other interrupts work (and MSI worked for other 
controllers), I don't think it's interrupt-routing related. Especially as 
MSI shouldn't even care about things like that.

And since it all works when "irqpoll" is used, that implies that the 
*only* thing that is broken is literally irq delivery.

Is there possibly some jmicron-specific "enable interrupts" bit? 

> PS : I'd like to try 2.6.21-rc3, but it seems that this is breaking my
> config : disk naming is no more the same, and I end up with a panic
> Warning: unable to open an initial console
> though i've been compiling with the same .config I was using for 2.6.21-rc2

Gaah. Can you get a log through serial console or netconsole to see what 
changed?

		Linus
