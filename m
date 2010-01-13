Return-Path: <linux-kernel-owner+w=401wt.eu-S932159Ab0AMSSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0AMSSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998Ab0AMSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:18:37 -0500
Received: from khc.piap.pl ([195.187.100.11]:38198 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab0AMSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:18:35 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	<m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
Date: Wed, 13 Jan 2010 19:18:32 +0100
In-Reply-To: <4B4DFE1A.4000606@pobox.com> (Jeff Garzik's message of "Wed, 13
	Jan 2010 12:08:42 -0500")
Message-ID: <m3iqb57ts7.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jgarzik@pobox.com> writes:

> I'm not sure I understand your point.  Are there ahci problems with
> the generic entries, that remain unresolved?

It seems JMB363 on MSI Neo2 motherboard (P45 + ICH10R) still doesn't
work correctly, flooding the kernel logs. No SATA devices connected,
a CD-ROM connected to PATA (and it works fine). I've sent a report to
the IDE  list some time ago, please let me know if you need more details
or testing etc.

JMB363 set in BIOS setup to non-RAID mode (it seems this means disabling
the JMB BIOS). Last tested with 2.6.32.1 x86-64 SMP. IRQ 16 is shared.

Currently the IRQ in PCI registers is 10 (JMB363 SATA is not handled),
I can enable and check again if needed.

02:00.0 SATA controller: JMicron Technologies, Inc. 20360/20363 Serial ATA Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Micro-Star International Co., Ltd. Device 7512
        Control: I/O+ Mem+ BusMaster+ the_rest-
        Status: Cap+ the_rest-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 5: Memory at fe9fe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>

ahci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ahci 0000:02:00.0: setting latency timer to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
ata8: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
ata8: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)

then every few seconds (ata8 only, nothing on ata7):

ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 300)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 300)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4060000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { PHYInt CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 310)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 310)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 310)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 310)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps
ata8: hard resetting link
ata8: SATA link down (SStatus 0 SControl 310)
ata8: EH complete
ata8: exception Emask 0x10 SAct 0x0 SErr 0x4060000 action 0xe frozen
ata8: irq_stat 0x00000040, connection status changed
ata8: SError: { PHYInt CommWake DevExch }
ata8: limiting SATA link speed to 1.5 Gbps

It seems it worked without the above few times (according to the logs),
though I can't repeat it even with the same kernel version.
Maybe setting the mode to RAID (= enabling the JMB BIOS) would fix it?
I can check if there is non-zero possibility.

I can't rule out a hw problem, though I think other people had similar
problems with this chip.
-- 
Krzysztof Halasa
