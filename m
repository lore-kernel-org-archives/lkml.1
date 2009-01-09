Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZAIMf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZAIMf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZAIMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:35:50 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:63611 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZAIMfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:35:48 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-ide@vger.kernel.org
Subject: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Fri, 9 Jan 2009 13:34:55 +0100
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091334.55823.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with todays git I lots of these warnings:

[    1.246807] ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
[    1.253066] ata1.00: 195371568 sectors, multi 16: LBA48
[    1.262561] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
[    1.273159] ata1.00: configured for UDMA/100
[    1.275279] ata2.00: configured for UDMA/33
[    1.285546] scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
[    1.292049] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.298427] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
[    1.299631] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
[    1.311059] sd 0:0:0:0: [sda] Write Protect is off
[    1.317409] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.317426] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.318378] ------------[ cut here ]------------
[    1.318380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
[    1.318381] Hardware name: 64575GG
[    1.318382] Modules linked in:
[    1.318384] Pid: 0, comm: swapper Not tainted 2.6.28-self-07939-g2150edc #66
[    1.318386] Call Trace:
[    1.318390]  [<c05412ac>] ? printk+0x18/0x1a
[    1.318393]  [<c014c803>] warn_slowpath+0x73/0xd0
[    1.318397]  [<c02b370f>] ? blk_complete_request+0x1f/0x30
[    1.318399]  [<c03857ab>] ? scsi_done+0xb/0x10
[    1.318401]  [<c03a49d4>] ? atapi_qc_complete+0x64/0x310
[    1.318405]  [<c039cd94>] ? __ata_qc_complete+0x64/0xd0
[    1.318407]  [<c039e565>] ? ata_qc_complete+0x95/0x1d0
[    1.318409]  [<c014863b>] ? default_wake_function+0xb/0x10
[    1.318411]  [<c03ad8f5>] ? ata_sff_data_xfer32+0x75/0xc0
[    1.318413]  [<c03ad40e>] ata_sff_hsm_move+0x45e/0x750
[    1.318416]  [<c03ae99a>] ata_sff_interrupt+0x14a/0x220
[    1.318419]  [<c017cd49>] handle_IRQ_event+0x39/0x70
[    1.318421]  [<c017e548>] handle_edge_irq+0xa8/0x130
[    1.318423]  [<c017e4a0>] ? handle_edge_irq+0x0/0x130
[    1.318425]  <IRQ>  [<c0151885>] ? irq_exit+0x75/0x90
[    1.318429]  [<c0120ae7>] ? common_interrupt+0x27/0x2c
[    1.318432]  [<c0127902>] ? mwait_idle+0x42/0x50
[    1.318434]  [<c011ec01>] ? cpu_idle+0x71/0xd0
[    1.318437]  [<c053e704>] ? start_secondary+0x18f/0x1fb
[    1.318440]  [<c0538084>] ? i8042_probe+0x586/0x5fa
[    1.318444] ---[ end trace d41a74a84afec9c1 ]---

cborntra@cborntra:/sys/bus/scsi$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST910021AS       Rev: 4.06
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-U10N  Rev: 1.05
  Type:   CD-ROM                           ANSI  SCSI revision: 05


Christian
