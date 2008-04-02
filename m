Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbYDBHRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbYDBHRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760683AbYDBHRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:17:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760651AbYDBHRR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:17:17 -0400
Date: Wed, 2 Apr 2008 00:16:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q? "J.A._Magall=F3n" ?= <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Again... DMA speed too slow
Message-Id: <20080402001640.41c103a7.akpm@linux-foundation.org>
In-Reply-To: <20080330235357.20a54963@werewolf>
References: <20080330235357.20a54963@werewolf>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008 23:53:57 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:

> Hi all...
> 
> I have tried to burn some data from the commandline with wodim (since time
> ago I just used beasero...), and I have noticed this (media is CD, not DVD):
> 
> Vendor_info    : 'HL-DT-ST'
> Identification : 'DVDRAM GSA-H10N '
> Revision       : 'JL12'
> Device seems to be: Generic mmc2 DVD-R/DVD-RW.
> Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
> Driver flags   : MMC-3 SWABAUDIO BURNFREE
> Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
> Speed set to 8467 KB/s
> wodim: DMA speed too slow (OK for 5x). Cannot write at speed 48x.
> Starting to write CD/DVD at speed  48.0 in real TAO mode for single session.
> 
> I just can burn CDs at 5x ??
> But then the program tries to write at 48x.
> It the DMA message really true ?
> 
> Accodring to wodim -prcap:
> 
>   Maximum read  speed: 22161 kB/s (CD 125x, DVD 16x)
>   Current read  speed: 22161 kB/s (CD 125x, DVD 16x)
>   Maximum write speed: 11080 kB/s (CD  62x, DVD  8x)
>   Current write speed: 11080 kB/s (CD  62x, DVD  8x)
>   Rotational control selected: CLV/PCAV
>   Buffer size in KB: 2048
>   Copy management revision supported: 1
>   Number of supported write speeds: 3
>   Write speed # 0: 11080 kB/s CLV/PCAV (CD  62x, DVD  8x)
>   Write speed # 1:  5540 kB/s CLV/PCAV (CD  31x, DVD  4x)
>   Write speed # 2:  3324 kB/s CLV/PCAV (CD  18x, DVD  2x)
> 
> Why the tests in wodim say that DMA to the drive is slow ?
> 
> Kernel is 2.6.24.4.
> The drive is controlled by libata+sata_promise:
> 
> sata_promise 0000:03:04.0: version 2.11
> ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 23 (level, low) -> IRQ 17
> scsi6 : sata_promise
> scsi7 : sata_promise
> scsi8 : sata_promise
> ata5: SATA max UDMA/133 mmio m4096@0xf6029000 port 0xf6029200 irq 17
> ata6: SATA max UDMA/133 mmio m4096@0xf6029000 port 0xf6029280 irq 17
> ata7: PATA max UDMA/133 mmio m4096@0xf6029000 port 0xf6029300 irq 17
> ata5: SATA link down (SStatus 0 SControl 300)
> ata6: SATA link down (SStatus 0 SControl 0)
> ata7.00: ATA-6: ST3120022A, 3.06, max UDMA/100
> ata7.00: 234441648 sectors, multi 0: LBA48
> ata7.01: ATAPI: HL-DT-ST DVDRAM GSA-H10N, JL12, max UDMA/33
> ata7.00: configured for UDMA/100
> ata7.01: configured for UDMA/33
> scsi 8:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
> sd 8:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
> sd 8:0:0:0: [sdd] Write Protect is off
> sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 8:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
> sd 8:0:0:0: [sdd] Write Protect is off
> sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sdd: sdd1
> sd 8:0:0:0: [sdd] Attached SCSI disk
> sd 8:0:0:0: Attached scsi generic sg3 type 0
> scsi 8:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H10N  JL12 PQ: 0 ANSI: 5
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> 
> UDMA/33 on the burner should be ok for 48x (150x48 = 7.2 MB/s) ?
> Or just 16x, as I read elsewhere ?
> 

Please always cc linux-ide on ata-related bug reports.

