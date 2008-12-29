Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYL2LR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYL2LR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYL2LRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:17:19 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:49337 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYL2LRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:17:19 -0500
Date: Mon, 29 Dec 2008 11:17:16 +0000
From: Nick Warne <nick@ukfsn.org>
To: Len Brown <lenb@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Rather high /proc/interrupts ERR count
Message-ID: <20081229111716.74131849@sauron.linicks.net>
In-Reply-To: <alpine.LFD.2.00.0812282225380.4738@localhost.localdomain>
References: <20081226085335.2ecd5cfb@sauron.linicks.net>
	<alpine.LFD.2.00.0812282225380.4738@localhost.localdomain>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 22:39:32 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> 
> On Fri, 26 Dec 2008, Nick Warne wrote:

> > ERR:     354616
> > MIS:          0
> 
> 21189+333431 = 354620
> 
> So virtually all of the ERR's are from IRQ7,
> which is how  the PIC identifies interrupts
> when it has no idea of the real source.
> 
> The PIC actually doesn't have a concept of directing
> interrupts to non CPU0, and the fact that CPU1
> on this box thinks it receives some of the interrupts
> is in the undocumented area known as "implementation specific"
> or maybe stated as "don't do this at home".
> 
> So the better thing to focus on would be how to get rid of
> "noapic" on your cmdline and get the system into IOAPIC
> mode, as it was designed to be.

Thanks Len - you explained it to me perfectly, and as suggested:

           CPU0       CPU1       
  0:        121        494   IO-APIC-edge      timer
  1:         17      20796   IO-APIC-edge      i8042
  6:          0          3   IO-APIC-edge      floppy
  7:          1          0   IO-APIC-edge    
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 14:          2        139   IO-APIC-edge      pata_amd
 15:          0          0   IO-APIC-edge      pata_amd
 16:         86      85163   IO-APIC-fasteoi   nvidia
 20:          0          4   IO-APIC-fasteoi   ehci_hcd:usb1
 21:          0          0   IO-APIC-fasteoi   sata_nv
 22:        570     404175   IO-APIC-fasteoi   sata_nv, Intel ICH
 23:       1236    8996739   IO-APIC-fasteoi   ohci_hcd:usb2, eth0
NMI:          0          0   Non-maskable interrupts
LOC:    4497869    5381066   Local timer interrupts
RES:     999249     570052   Rescheduling interrupts
CAL:     105254     112444   Function call interrupts
TLB:      14640       6594   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0

Now appears fine (I get one ERR at boot, for some reason).

Thanks for the information.

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
