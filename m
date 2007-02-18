Return-Path: <linux-kernel-owner+w=401wt.eu-S2993075AbXBRCJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993075AbXBRCJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993076AbXBRCJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:09:34 -0500
Received: from userg500.nifty.com ([202.248.238.80]:28300 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993075AbXBRCJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:09:33 -0500
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	b=sDLiGG0z2bZZryr5sEcgemL5OGNi7Fh/i4ikm7mJ8m+5ulZQi7h5EaOqTq0L18qAP
	j+KNX6W7VGHgBnNCCuscA==
Date: Sun, 18 Feb 2007 11:09:14 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-Id: <20070218110914.888de729.komurojun-mbn@nifty.com>
In-Reply-To: <20070211114013.65b2be2c.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I tried the kernel 2.6.20-git14,
the pata_pcmcia drive works properly.Thanks!

But I do the "pccardctl eject"
NULL-pointer-dereference error happens.


[dmesg]
pcmcia: registering new device pcmcia1.0
SCSI subsystem initialized
libata version 2.10 loaded.
ata1: PATA max PIO0 cmd 0x0001d100 ctl 0x0001d10e bmdma 0x00000000 irq 3
scsi0 : pata_pcmcia
ata1.00: CFA: Hitachi XXM2.3.0, Rev 3.00, max PIO1
ata1.00: 62592 sectors, multi 0: LBA 
ata1.00: configured for PIO0
scsi 0:0:0:0: Direct-Access     ATA      Hitachi XXM2.3.0 Rev  PQ: 0 ANSI: 5
scsi 0:0:0:0: Attached scsi generic sg0 type 0
SCSI device sda: 62592 512-byte hdwr sectors (32 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 62592 512-byte hdwr sectors (32 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: Attached scsi removable disk sda
pccard: card ejected from slot 1
ata1.00: disabled
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000020
 printing eip:
d89f7f3e
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: nls_ascii vfat fat sd_mod sg pata_pcmcia libata scsi_mod dm_mirror dm_multipath dm_mod pcmcia yenta_socket rsrc_nonstatic pcmcia_core
CPU:    0
EIP:    0060:[<d89f7f3e>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-git14 #1)
EIP is at ata_host_release+0x2e/0x48 [libata]
eax: d7981884   ebx: d545b8c0   ecx: d7f6f180   edx: d545b8cc
esi: 00000000   edi: 00000000   ebp: 00000000   esp: d5bfde58
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process pccardctl (pid: 1711, ti=d5bfc000 task=c13d1540 task.ti=d5bfc000)
Stack: d545b8c0 d5ac4700 d7981a24 c0220120 d7981a24 d7981884 00000006 d5ac4720 
       d5ac4660 d7981884 d887c278 d71c8dbc d7c53c48 c02201e9 00000286 d7981884 
       c021d363 d7981884 d7981884 c021d7ae d798192c c021cd84 d7981884 d7981884 
Call Trace:
 [<c0220120>] release_nodes+0x10f/0x12f
 [<c02201e9>] devres_release_all+0x27/0x2a
 [<c021d363>] __device_release_driver+0x78/0x8e
 [<c021d7ae>] device_release_driver+0x31/0x46
 [<c021cd84>] bus_remove_device+0x6d/0x7d
 [<c021b58a>] device_del+0x162/0x1bf
 [<c021b5ef>] device_unregister+0x8/0x10
 [<d88304b9>] pcmcia_card_remove+0x66/0x81 [pcmcia]
 [<d883143d>] ds_event+0x4a/0x6d [pcmcia]
 [<c01b6db5>] kobject_get+0xf/0x13
 [<d88172da>] send_event+0x31/0x49 [pcmcia_core]
 [<d88174b9>] socket_shutdown+0xc/0xb3 [pcmcia_core]
 [<d881757c>] socket_remove+0x1c/0x26 [pcmcia_core]
 [<d88175c5>] pcmcia_eject_card+0x3f/0x4c [pcmcia_core]
 [<d8819e48>] pccard_store_eject+0x1b/0x22 [pcmcia_core]
 [<d8819e2d>] pccard_store_eject+0x0/0x22 [pcmcia_core]
 [<c021af3b>] dev_attr_store+0x27/0x2c
 [<c017d1cb>] sysfs_write_file+0xbc/0xe5
 [<c017d10f>] sysfs_write_file+0x0/0xe5
 [<c014df18>] vfs_write+0x8a/0x10c
 [<c014e3ae>] sys_write+0x41/0x67
 [<c0103c76>] sysenter_past_esp+0x5f/0x85
 [<c02b0000>] wait_for_completion+0x33/0xaf
 =======================
Code: 56 53 8b b0 50 01 00 00 eb 21 8b 5c be 34 85 db 74 18 8b 43 04 8b 90 88 00 00 00 85 d2 74 04 89 d8 ff d2 8b 03 e8 fa 0d e6 ff 47 <3b> 7e 20 72 da 8b 46 28 8b 90 8c 00 00 00 85 d2 74 04 89 f0 ff 
EIP: [<d89f7f3e>] ata_host_release+0x2e/0x48 [libata] SS:ESP 0068:d5bfde58

Best Regards
Komuro

