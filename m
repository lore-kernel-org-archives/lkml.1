Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbXBXXO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbXBXXO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933590AbXBXXO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:14:26 -0500
Received: from userg502.nifty.com ([202.248.238.82]:59281 "EHLO
	userg502.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbXBXXOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:14:25 -0500
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	b=wykNp8/iArpvhzvyPMKP3kOdRL5OlqWpWxahfYCKSlKJdS49BzVeK3LHlSjhmRbdY
	khcgp7KrvhbZreiY2bbQg==
Date: Sun, 25 Feb 2007 08:14:07 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-Id: <20070225081407.8ebce421.komurojun-mbn@nifty.com>
In-Reply-To: <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
	<20070218110914.888de729.komurojun-mbn@nifty.com>
	<20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The pata_pcmcia problem is fixed. Thanks!
(I tested it on kernel 2.6.20-git14)

But kernel 2.6.20-mm2 introduced new oops
when I insert the pata_pcmcia device.


pcmcia: registering new device pcmcia1.0
SCSI subsystem initialized
libata version 2.10 loaded.
ata1: PATA max PIO0 cmd 0x0001d100 ctl 0x0001d10e bmdma 0x00000000 irq 3
scsi0 : pata_pcmcia
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000004d
 printing eip:
d8a1b10e
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /block/hda/size
Modules linked in: pata_pcmcia libata scsi_mod dm_mirror dm_multipath dm_mod pcmcia yenta_socket rsrc_nonstatic pcmcia_core
CPU:    0
EIP:    0060:[<d8a1b10e>]    Not tainted VLI
EFLAGS: 00010296   (2.6.20-mm2 #1)
EIP is at ata_acpi_exec_tfs+0x157/0x8ad [libata]
eax: 00000001   ebx: 00000000   ecx: d6d43c84   edx: d6d43c84
esi: d51f4514   edi: 00000000   ebp: d51f438c   esp: d6f2bcdc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process scsi_eh_0 (pid: 1647, ti=d6f2a000 task=c13c9a70 task.ti=d6f2a000)
Stack: d51f6190 00000246 00000246 00000000 d8a130b7 00000000 00000000 00000000 
       00000000 d6f2bd48 d6f2bdf0 d51f4514 ec000000 d51f6190 00000000 00000000 
       00000000 00000246 d6d43c84 00000000 00000000 00000000 00000000 ffffffff 
Call Trace:
 [<d8a130b7>] ata_exec_internal_sg+0x3ae/0x3b8 [libata]
 [<d8a125f8>] ata_dev_configure+0xc1/0x7d2 [libata]
 [<d8a10e87>] ata_dev_select+0xce/0x11a [libata]
 [<d8a1324e>] ata_dev_read_id+0xe0/0x2d1 [libata]
 [<d8a19c7f>] ata_do_eh+0x1235/0x16de [libata]
 [<d8a1234d>] ata_std_softreset+0x0/0xbe [libata]
 [<d8a14270>] ata_std_prereset+0x0/0x127 [libata]
 [<c011ebe9>] cancel_work_sync+0x1c/0x87
 [<d8a17c2a>] ata_bmdma_drive_eh+0xd2/0x167 [libata]
 [<d8a1234d>] ata_std_softreset+0x0/0xbe [libata]
 [<d8a17cf2>] ata_bmdma_error_handler+0x33/0x37 [libata]
 [<d8a1210e>] ata_std_postreset+0x0/0x7e [libata]
 [<d8a1a707>] ata_scsi_error+0x223/0x4b4 [libata]
 [<d885b956>] scsi_error_handler+0x0/0x490 [scsi_mod]
 [<d885ba16>] scsi_error_handler+0xc0/0x490 [scsi_mod]
 [<c02bb445>] _spin_unlock_irq+0x5/0x7
 [<c02b9d9c>] __sched_text_start+0x4e4/0x569
 [<c010eaca>] __wake_up_common+0x32/0x55
 [<d885b956>] scsi_error_handler+0x0/0x490 [scsi_mod]
 [<c0120b4f>] kthread+0xa0/0xc9
 [<c0120aaf>] kthread+0x0/0xc9
 [<c0103f3f>] kernel_thread_helper+0x7/0x10
 =======================
Code: 0f 84 e1 00 00 00 8b 54 24 48 c7 44 24 5c ff ff ff ff 8b 4c 24 48 c7 44 24 60 00 00 00 00 83 ea 48 8b 42 10 8b 5a 20 8b 54 24 48 <8b> 78 4c 8b 92 8c 01 00 00 89 54 24 44 8b 81 a4 00 00 00 8d 54 
EIP: [<d8a1b10e>] ata_acpi_exec_tfs+0x157/0x8ad [libata] SS:ESP 0068:d6f2bcdc

Best Regards
Komuro
