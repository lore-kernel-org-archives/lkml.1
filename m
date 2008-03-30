Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbYC3TZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbYC3TZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYC3TZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:25:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYC3TZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:25:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chr <chunkeey@web.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Sun, 30 Mar 2008 21:25:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200803302109.22219.chunkeey@web.de>
In-Reply-To: <200803302109.22219.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302125.10817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added some CCs]

On Sunday, 30 of March 2008, Chr wrote:
> Hi,
> 
> Ever since I went to the new 2.6.25-rcX, I encountered lots of random
> system freezes after about 2 or 3 hours of uptime... but until now, 
> I couldn't _catch_ them, since the system
> (AMD Athlon 4200+ X2 (Manchester) / nforce 4 SLI / x86_64) went
> straight into oblivion (nothing on the serial console or anywhere else,
> heck I couldn't even hit reset, It didn't POST anymore)
> 
> So. take a look at stuck_task... that's best backtrace I could get...
> (I have other logs too. (Task-list / Lockdep / ... ) but it's too much
> and I hope the _logs_ are already enough.
> 
> BTW: I noticed that the clock seems to jump forward and backwards.
> Is this because the CPU-Cores aren't syncronized? (And why are they
> out of sync?)
> 
> (And yes, 2.6.24.4 is fine... even hpet works there without any
> rtc: lost 14 interrupts)
> 
> cat /proc/interrupts
>            CPU0       CPU1
>   0:         51          0    XT-PIC-XT        timer
>   1:         43      22170   IO-APIC-edge      i8042
>   4:          0          1   IO-APIC-edge
>   6:          0          5   IO-APIC-edge      floppy
>   7:          1          0   IO-APIC-edge      parport0
>   8:          0        199   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  14:          0          0   IO-APIC-edge      pata_amd
>  15:          0          0   IO-APIC-edge      pata_amd
>  16:         82      51311   IO-APIC-fasteoi   firewire_ohci, EMU10K1
>  17:          0         50   IO-APIC-fasteoi   firewire_ohci, eth1
>  18:         12       4862   IO-APIC-fasteoi   nvidia
>  20:        421     304857   IO-APIC-fasteoi   eth0
>  21:         57      33025   IO-APIC-fasteoi   ohci_hcd:usb1
>  22:        185      12275   IO-APIC-fasteoi   sata_nv
>  23:        276      83270   IO-APIC-fasteoi   sata_nv, ehci_hcd:usb2
> NMI:          0          0   Non-maskable interrupts
> LOC:     339847     307599   Local timer interrupts
> RES:     126709      38837   Rescheduling interrupts
> CAL:        605       1054   function call interrupts
> TLB:       1513       3813   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          1
> 
