Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYL2Djo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYL2Djo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYL2Djg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:39:36 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:64295 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYL2Djf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:39:35 -0500
Date: Sun, 28 Dec 2008 22:39:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [QUESTION] Rather high /proc/interrupts ERR count
In-reply-to: <20081226085335.2ecd5cfb@sauron.linicks.net>
X-X-Sender: lenb@localhost.localdomain
To: Nick Warne <nick@ukfsn.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0812282225380.4738@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081226085335.2ecd5cfb@sauron.linicks.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Dec 2008, Nick Warne wrote:

> Hi all,
> 
> Running 2.6.28 stable.
> 
> x86_64 system with AMD Athlon(tm) 64 X2 Dual Core Processor 5200+
> 
> The machine runs perfectly fine, but...
> 
> ...should I be concerned with the rather high ERR count below (this
> is after 41 minutes uptime).  I also have to boot with noapic to stop
> lockups (nvidia driver, I expect):
> 
>            CPU0       CPU1       
>   0:        125          1    XT-PIC-XT        timer
>   1:       5534         97    XT-PIC-XT        i8042
>   2:          0          0    XT-PIC-XT        cascade
>   3:          1          0    XT-PIC-XT      
>   4:          1          1    XT-PIC-XT      
>   5:      78933      11713    XT-PIC-XT        sata_nv, ohci_hcd:usb2, Intel ICH
>   6:          3          0    XT-PIC-XT        floppy
>   7:      21189     333431    XT-PIC-XT      
>   8:          1          0    XT-PIC-XT        rtc0
>   9:          0          0    XT-PIC-XT        acpi
>  10:     246562       9267    XT-PIC-XT        eth0
>  11:       2296         72    XT-PIC-XT        sata_nv, ehci_hcd:usb1, nvidia
>  14:         98         51    XT-PIC-XT        pata_amd
>  15:          0          0    XT-PIC-XT        pata_amd
> NMI:          0          0   Non-maskable interrupts
> LOC:     236200     234958   Local timer interrupts
> RES:      33224      73287   Rescheduling interrupts
> CAL:        890        964   Function call interrupts
> TLB:        982       1127   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> ERR:     354616
> MIS:          0

21189+333431 = 354620

So virtually all of the ERR's are from IRQ7,
which is how  the PIC identifies interrupts
when it has no idea of the real source.

The PIC actually doesn't have a concept of directing
interrupts to non CPU0, and the fact that CPU1
on this box thinks it receives some of the interrupts
is in the undocumented area known as "implementation specific"
or maybe stated as "don't do this at home".

So the better thing to focus on would be how to get rid of
"noapic" on your cmdline and get the system into IOAPIC
mode, as it was designed to be.

-- Len Brown, Intel Open Source Technology Center> 

