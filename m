Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYLMDzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYLMDzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 22:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYLMDzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 22:55:06 -0500
Received: from main.gmane.org ([80.91.229.2]:54652 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbYLMDzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 22:55:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Help interpreting AHCI failure messages
Date: Fri, 12 Dec 2008 21:52:28 -0600
Message-ID: <4943317C.8000807@shaw.ca>
References: <4942D651.1050306@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-ide@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <4942D651.1050306@goop.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi,
> 
> I'm trying to bring up the AHCI driver on a Xen dom0 kernel.  There's 
> almost certainly some problem with my DMA handling somewhere - or 
> perhaps interrupt routing - which is causing the AHCI driver to fail thus:
> 
> xen_set_ioapic_routing: irq 31 gsi 18 vector 184 ioapic 0 pin 18
> triggering 0 polarity 1ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, 
> low) -> IRQ 31
> xen: PCI device 0000:00:1f.2 pin 3 -> irq 31
> ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x27 impl SATA 
> mode
> ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> scsi4 : ahci
> scsi5 : ahci
> ata1: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970100 irq 31
> ata2: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970180 irq 31
> ata3: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970200 irq 31
> ata4: DUMMY
> ata5: DUMMY
> ata6: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970380 irq 31
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-H73N, B103, max UDMA/100
> ata2.00: configured for UDMA/100
> ata3: SATA link down (SStatus 4 SControl 300)
> ata6: SATA link down (SStatus 4 SControl 300)
> scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H73N B103 PQ: 0 
> ANSI: 5
> sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 1:0:0:0: Attached scsi generic sg0 type 5
> 
> 
> I'm wondering if you can give me a clue as to what might be failing on 
> the AHCI side to give these symptoms, so I have some idea where I need 
> to fix things in my code?

The timeouts would tend to suggest interrupts aren't getting through, 
you can check /proc/interrupts and see if that IRQ has gotten any 
interrupts at all..

