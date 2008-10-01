Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYJAAJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYJAAJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYJAAIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:08:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbYJAAIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:08:52 -0400
Date: Tue, 30 Sep 2008 17:08:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: gettinther <gettinther@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with
 the 2.6.26.5 kernel
Message-Id: <20080930170849.52c00228.akpm@linux-foundation.org>
In-Reply-To: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com>
References: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

On Tue, 30 Sep 2008 00:01:34 +0100 gettinther <gettinther@gmail.com> wrote:

> Hi,
> 
> I'm currently trying to get the 2.6.26.5 kernel to work but cannot get
> the sata dvdrom to be recognized by the MCP55.  The controller works
> with the 2.6.24.4 and 2.6.25.17 kernels.  I had to use
> CONFIG_ACPI_DOCK=y for the 2.6.25.17 but this did not work with the
> 2.6.26.5.  The problem has been confirmed on at least 2 machines.

It's a regression.

> I have tried various boot options (pci=nomsi, acpi=off and any other
> relevant code I could find) but nothing seems to work.  The odd thing
> is the sata dvdrom was recognized twice by the 2.6.26.5 kernel (2
> different kernel tests) for no apparent reason (could not get it to
> work afterward).
> 
> Here's the cut info for each kernel from /var/log/messages (2.6.25.17,
> 2.6.26.5 working, 2.6.26.5 not working).  If you require further
> information I can submit it. I don't want to put too much on the first
> message.
> 
> Thank you
> 
> Cyrille
> 
> Kernel-2.6.25.17, working
> 
> Sep 28 14:49:43 localhost kernel: SCSI subsystem initialized
> Sep 28 14:49:43 localhost kernel: ACPI: PCI Interrupt Link [LSA0]
> enabled at IRQ 23
> Sep 28 14:49:43 localhost kernel: ACPI: PCI Interrupt 0000:00:05.0[A]
> -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
> Sep 28 14:49:43 localhost kernel: scsi0 : sata_nv
> Sep 28 14:49:43 localhost kernel: scsi1 : sata_nv
> Sep 28 14:49:43 localhost kernel: ata1: SATA max UDMA/133 cmd 0xc480
> ctl 0xc400 bmdma 0xbc00 irq 23
> Sep 28 14:49:43 localhost kernel: ata2: SATA max UDMA/133 cmd 0xc080
> ctl 0xc000 bmdma 0xbc08 irq 23
> Sep 28 14:49:43 localhost kernel: ata1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Sep 28 14:49:43 localhost kernel: ata1.00: ATA-7: ST3120211AS, 3.AAE,
> max UDMA/133
> Sep 28 14:49:43 localhost kernel: ata1.00: 234441648 sectors, multi
> 16: LBA48 NCQ (depth 0/32)
> Sep 28 14:49:43 localhost kernel: ata1.00: configured for UDMA/133
> Sep 28 14:49:43 localhost kernel: input: ImPS/2 Generic Wheel Mouse as
> /class/input/input1
> Sep 28 14:49:43 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 14:49:43 localhost kernel: ata2.00: ATAPI: DVDRW IDE H16X, VER
> B02K, max UDMA/33
> Sep 28 14:49:43 localhost kernel: ata2.00: applying bridge limits
> Sep 28 14:49:43 localhost kernel: ata2.00: configured for UDMA/33
> Sep 28 14:49:43 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA
>     ST3120211AS      3.AA PQ: 0 ANSI: 5
> Sep 28 14:49:43 localhost kernel: scsi 1:0:0:0: CD-ROM
> DVDRW    IDE H16X         B02K PQ: 0 ANSI: 5
> 
> Kernel-2.6.26.5, Successful launch
> 
> Sep 28 14:52:39 localhost kernel: SCSI subsystem initialized
> Sep 28 14:52:39 localhost kernel: ACPI: PCI Interrupt Link [LSA0]
> enabled at IRQ 23
> Sep 28 14:52:39 localhost kernel: ACPI: PCI Interrupt 0000:00:05.0[A]
> -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
> Sep 28 14:52:39 localhost kernel: sata_nv 0000:00:05.0: Using SWNCQ mode
> Sep 28 14:52:39 localhost kernel: scsi0 : sata_nv
> Sep 28 14:52:39 localhost kernel: scsi1 : sata_nv
> Sep 28 14:52:39 localhost kernel: ata1: SATA max UDMA/133 cmd 0xc480
> ctl 0xc400 bmdma 0xbc00 irq 23
> Sep 28 14:52:39 localhost kernel: ata2: SATA max UDMA/133 cmd 0xc080
> ctl 0xc000 bmdma 0xbc08 irq 23
> Sep 28 14:52:39 localhost kernel: ata1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Sep 28 14:52:39 localhost kernel: ata1.00: ATA-7: ST3120211AS, 3.AAE,
> max UDMA/133
> Sep 28 14:52:39 localhost kernel: ata1.00: 234441648 sectors, multi
> 16: LBA48 NCQ (depth 31/32)
> Sep 28 14:52:39 localhost kernel: ata1.00: configured for UDMA/133
> Sep 28 14:52:39 localhost kernel: input: ImPS/2 Generic Wheel Mouse as
> /class/input/input1
> Sep 28 14:52:39 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 14:52:39 localhost kernel: ata2.00: ATAPI: DVDRW IDE H16X, VER
> B02K, max UDMA/33
> Sep 28 14:52:39 localhost kernel: ata2.00: applying bridge limits
> Sep 28 14:52:39 localhost kernel: ata2.00: Drive reports diagnostics
> failure. This may indicate a drive
> Sep 28 14:52:39 localhost kernel: ata2.00: fault or invalid emulation.
> Contact drive vendor for information.
> Sep 28 14:52:39 localhost kernel: ata2.00: configured for UDMA/33
> Sep 28 14:52:39 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA
>     ST3120211AS      3.AA PQ: 0 ANSI: 5
> Sep 28 14:52:39 localhost kernel: scsi 1:0:0:0: CD-ROM
> DVDRW    IDE H16X         B02K PQ: 0 ANSI: 5
> 
> Kernel-2.6.26.5, Failed launches
> 
> Sep 28 15:08:11 localhost syslogd 1.4.1: restart.
> Sep 28 15:08:11 localhost INIT: Loading ACPI module wmi: successfull
> Sep 28 15:08:11 localhost kernel: klogd 1.4.1, log source = /proc/kmsg started.
> Sep 28 15:08:11 localhost kernel: Inspecting /boot/System.map-2.6.26.5.tex3
> Sep 28 15:08:11 localhost crond[2823]: (CRON) STARTUP (V5.0)
> Sep 28 15:08:12 localhost kernel: Loaded 29671 symbols from
> /boot/System.map-2.6.26.5.tex3.
> Sep 28 15:08:12 localhost kernel: Symbols match kernel version 2.6.26.
> Sep 28 15:08:12 localhost kernel: No module symbols loaded - kernel
> modules not enabled.
> Sep 28 15:08:12 localhost kernel: ta1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Sep 28 15:08:12 localhost kernel: ata1.00: ATA-7: ST3120211AS, 3.AAE,
> max UDMA/133
> Sep 28 15:08:12 localhost kernel: ata1.00: 234441648 sectors, multi
> 16: LBA48 NCQ (depth 31/32)
> Sep 28 15:08:12 localhost kernel: ata1.00: configured for UDMA/133
> Sep 28 15:08:12 localhost kernel: input: ImPS/2 Generic Wheel Mouse as
> /class/input/input1
> Sep 28 15:08:12 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 15:08:12 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
> Sep 28 15:08:12 localhost kernel: ata2.00: failed to IDENTIFY (I/O
> error, err_mask=0x4)
> Sep 28 15:08:12 localhost kernel: ata2: failed to recover some
> devices, retrying in 5 secs
> Sep 28 15:08:12 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 15:08:12 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
> Sep 28 15:08:12 localhost kernel: ata2.00: failed to IDENTIFY (I/O
> error, err_mask=0x4)
> Sep 28 15:08:12 localhost kernel: ata2: failed to recover some
> devices, retrying in 5 secs
> Sep 28 15:08:12 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 15:08:12 localhost kernel: ata2.00: qc timeout (cmd 0xa1)
> Sep 28 15:08:12 localhost kernel: ata2.00: failed to IDENTIFY (I/O
> error, err_mask=0x4)
> Sep 28 15:08:12 localhost kernel: ata2: failed to recover some
> devices, retrying in 5 secs
> Sep 28 15:08:12 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus
> 113 SControl 300)
> Sep 28 15:08:12 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA
>     ST3120211AS      3.AA PQ: 0 ANSI: 5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
