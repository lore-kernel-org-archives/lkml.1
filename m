Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXIVDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXIVDTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXIVDTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 23:19:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:56777 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbXIVDTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 23:19:39 -0400
To: Andi Kleen <ak@suse.de>
Cc: joe.korty@ccur.com, thockin@hockin.org, mingo@elte.hu, hpa@zytor.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: possible corrections in the docs (Re: [PATCH] [7/50] x86: expand /proc/interrupts to include missing vectors, v2)
In-Reply-To: <20070921223205.51E0113DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de> <20070921223205.51E0113DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 05:35:15 +0200
Message-Id: <E1IYvlz-0006DE-W1@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 22 Sep 2007 00:32:05 +0200 (CEST)

[]
> Index: linux/Documentation/filesystems/proc.txt
>===================================================================
> --- linux.orig/Documentation/filesystems/proc.txt
> +++ linux/Documentation/filesystems/proc.txt
> @@ -347,7 +347,40 @@ connects the CPUs in a SMP system. This 
>  the IO-APIC automatically retry the transmission, so it should not be a big
>  problem, but you should read the SMP-FAQ.
>  
> -In this context it could be interesting to note the new irq directory in 2.4.
> +In 2.6.2* /proc/interrupts was expanded again.  This time the goal was for
> +/proc/interrupts to display every IRQ vector in use by the system, not
> +just those considered 'most important'.  The new vectors are:
> +
> +  THR -- a threshold interrupt occurs when ECC memory correction is occuring
> +  at too high a frequency.  Threshold interrupt machinery is often put
> +  into the ECC logic, as occasional ECC memory corrections are part of
> +  normal operation (due to random alpha particles), but sequences of
> +  ECC corrections or outright failures over some short interval usually
> +  indicate a memory chip that is about to fail.  Note that not every
> +  platform has ECC threshold logic, and those that do generally require
> +  it to be explicitly turned on.

 +  THR -- a threshold interrupt happens, when frequency of ECC memory
 +  corrections is too high. Threshold interrupt machinery is often put
 +  into the ECC hardware, and must be explicitly enabled, if so. Occasional
 +  ECC memory corrections are part of the normal operation (ionizing radiation
 +  background). Sequences of ECC corrections or outright failures over some
 +  short interval, usually indicate a memory chip, that is about to fail
 +  completely.

(that "random alpha particles" bs, must be killed anyway)

> +  TRM -- a thermal event interrupt occurs when a temperature threshold
> +  has been exceeded for some CPU chip.  This interrupt may also be generated
> +  when the temperature drops back to normal.
> +
> +  SPU -- a spurious interrupt is some interrupt that was raised then lowered
> +  by some IO device before it could be fully processed by the APIC.  Hence
> +  the APIC sees the interrupt but does not know what device it came from.
> +  For this case the APIC will generate the interrupt with a IRQ vector
> +  of 0xff.

 +  SPU -- a spurious interrupt. This is an interrupt, that was raised then lowered
 +  so quickly, that it was not fully processed by the APIC.  Hence,
 +  origin of it is unknown.
 +  For this case, interrupt with a IRQ vector of 0xff will be generated.

> +  RES, CAL, TLB -- rescheduling, call and tlb flush interrupts are
> +  sent from one CPU to another per the needs of the OS.  Typically,
> +  their statistics are used by kernel developers and interested users to
> +  determine the occurance of interrupt floods of the given type.

 +  RES, CAL, TLB -- rescheduling, call and tlb flush interrupts,
 +  produced by normal OS operation.  Typically,
 +  this information is used by kernel developers and interested users to
 +  determine the occurance of interrupt floods of the given type.


> +The above IRQ vectors are displayed only when relevent.  For example,
                                                 available?
> +the threshold vector does not exist on x86_64 platforms.  Others are
> +suppressed when the system is a uniprocessor.  As of this writing, only
> +i386 and x86_64 platforms support the new IRQ vector displays.
> +
> +Of some interest is the introduction of the /proc/irq directory to 2.4.
>  It could be used to set IRQ to CPU affinity, this means that you can "hook" an
>  IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
>  irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
_____
