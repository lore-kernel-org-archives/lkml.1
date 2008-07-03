Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYGCVns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYGCVns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYGCVnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:43:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:44938 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbYGCVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KRnsJXBZBRX6jfBdSgZqPQM6hw67ZEMleg2xPPmRp5jzjT6OYNCUfJaWJBh07kSuW7
         TBcHaC/pxG1ZhpMGl5gG+P9OSdFkx0V6E1GnBpeRm7l4oW8y7Fp0HEepntxyUmvc6hq5
         eXKzXm/phlfa+CNgAQPVDcG2+Dn3Lrr5ASlzk=
Message-ID: <a4423d670807031443v73def4d2g97c9d6acc4b4e941@mail.gmail.com>
Date: Fri, 4 Jul 2008 01:43:31 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc: host can not shutdown: ata problem
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

A host does not go down.
I also tried it with `irqpoll` with the same result.


Remaining filesystems read-only ...
 / ...
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.26-rc8 #2
 [<c0141678>] __report_bad_irq+0x2e/0x6f
 [<c014187f>] note_interrupt+0x1c6/0x21f
 [<c0140fee>] ? handle_IRQ_event+0x3e/0x46
 [<c0141e11>] handle_fasteoi_irq+0x86/0xab
 [<c0141d8b>] ? handle_fasteoi_irq+0x0/0xab
 [<c0104c54>] do_IRQ+0xb6/0xe2
 [<c0101daf>] ? default_idle+0x0/0x55
 [<c0101daf>] ? default_idle+0x0/0x55
 [<c010372e>] common_interrupt+0x2e/0x34
 [<c0101daf>] ? default_idle+0x0/0x55
 [<c0101daf>] ? default_idle+0x0/0x55
 [<c0101de4>] ? default_idle+0x35/0x55
 [<c0101d7a>] cpu_idle+0x62/0x97
 [<c0353270>] rest_init+0x5c/0x5e
 =======================
handlers:
[<c02df1df>] (ata_sff_interrupt+0x0/0xab)
Disabling IRQ #18
atkbd serio0: shutdown
i8042 i8042: shutdown
sd 3:0:1:0: shutdown
sd 3:0:1:0: [sdd] Synchronizing SCSI cache
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4: EH complete
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4: EH complete
ata4.00: limiting speed to UDMA/66:PIO4

and so on ..


Controller is
Promise Technology, Inc. PDC20270 (FastTrak100 LP/TX2/TX4) (rev 02)

pata_pdc2027x 0000:01:0a.0: PLL input clock 16692 kHz
scsi2 : pata_pdc2027x
scsi3 : pata_pdc2027x
ata3: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0417c0 irq 18
ata4: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0415c0 irq 18
ata3.00: ATA-7: ST3250823A, 3.03, max UDMA/100
ata3.00: 488397168 sectors, multi 16: LBA48
ata3.00: configured for UDMA/100
ata4.01: HPA detected: current 488395055, native 488397168
ata4.01: ATA-7: ST3250824A, 3.AAD, max UDMA/100
ata4.01: 488395055 sectors, multi 16: LBA48
ata4.01: configured for UDMA/100
