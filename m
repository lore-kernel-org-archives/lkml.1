Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZINV2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZINV2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZINV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:28:06 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56466 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZINV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WvelCrdcdZiwJOXdO/fqp9OsLPmkuZYkO1SMipR1ac7edhSLRgI3PE2vgNbLTMbB41
         ixZDUdJhMPcZxcSw0VslwgsbdHfi5JxzvenoQMZnjgCIIgkO369RTdQUE4vmSI+w/JX5
         hQTmesoFsCf/xV92SGzHqd9oRIDJoSfR9B1JA=
MIME-Version: 1.0
Date: Tue, 15 Sep 2009 01:28:06 +0400
Message-ID: <a4423d670909141428j7d853496ub1891f55c6867798@mail.gmail.com>
Subject: 2.6.32: libata warning at ata_qc_complete() and "HPA support seems 
	broken"
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Host has pata_amd

ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15

and pata_pdc2027x.

pata_pdc2027x 0000:01:08.0: version 1.0
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
pata_pdc2027x 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level,
high) -> IRQ 16
pata_pdc2027x 0000:01:08.0: PLL input clock 16687 kHz
ata3: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0417c0 irq 16
ata4: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0415c0 irq 16

------------[ cut here ]------------
WARNING: at drivers/ata/libata-core.c:5027 ata_qc_complete+0x1ad/0x1d0()
Hardware name:
Modules linked in:
Pid: 529, comm: scsi_eh_3 Not tainted 2.6.31-03123-g99bc470 #4
Call Trace:
 [<c133f41a>] ? printk+0x18/0x1e
 [<c102983d>] warn_slowpath_common+0x6d/0xa0
 [<c124d93d>] ? ata_qc_complete+0x1ad/0x1d0
 [<c124d93d>] ? ata_qc_complete+0x1ad/0x1d0
 [<c1029885>] warn_slowpath_null+0x15/0x20
 [<c124d93d>] ata_qc_complete+0x1ad/0x1d0
 [<c125a88a>] ata_do_link_abort+0xba/0xe0
 [<c125a8ba>] ata_port_abort+0xa/0x10
 [<c125a8de>] ata_port_freeze+0x1e/0x40
 [<c124f4b7>] ata_exec_internal_sg+0x4a7/0x520
 [<c124e06a>] ? T.949+0x2a/0x50
 [<c133fb19>] ? wait_for_common+0xd9/0x130
 [<c124f58d>] ata_exec_internal+0x5d/0x80
 [<c1250679>] ata_dev_configure+0x669/0x1760
 [<c124f58d>] ? ata_exec_internal+0x5d/0x80
 [<c12601d5>] ? pdc2027x_cable_detect+0x25/0x60
 [<c125a08d>] ata_eh_recover+0x7dd/0xcc0
 [<c125bf90>] ? ata_sff_postreset+0x0/0x70
 [<c125cea0>] ? ata_sff_softreset+0x0/0x160
 [<c1260700>] ? pdc2027x_prereset+0x0/0x50
 [<c125a5af>] ata_do_eh+0x3f/0xb0
 [<c125bf90>] ? ata_sff_postreset+0x0/0x70
 [<c125cea0>] ? ata_sff_softreset+0x0/0x160
 [<c1260700>] ? pdc2027x_prereset+0x0/0x50
 [<c125be1e>] ata_sff_error_handler+0xee/0x1f0
 [<c125bf90>] ? ata_sff_postreset+0x0/0x70
 [<c125cea0>] ? ata_sff_softreset+0x0/0x160
 [<c125af2f>] ata_scsi_error+0x50f/0x780
 [<c133f7d8>] ? schedule+0x288/0x440
 [<c123c889>] scsi_error_handler+0xb9/0x340
 [<c123c7d0>] ? scsi_error_handler+0x0/0x340
 [<c103c6cc>] kthread+0x6c/0x80
 [<c103c660>] ? kthread+0x0/0x80
 [<c100355f>] kernel_thread_helper+0x7/0x18
---[ end trace a450bfd65efbd88e ]---
ata4.00: qc timeout (cmd 0x27)
ata4.00: failed to read native max address (err_mask=0x4)
ata4.00: HPA support seems broken, skipping HPA handling
