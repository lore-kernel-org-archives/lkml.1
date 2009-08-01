Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZHAWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZHAWoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZHAWoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:44:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52825 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZHAWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CWZi1xmvDP3MXUBGx+4gN18Jc4SbvCplOPftFRi9e/+Rq8nDEOBSChfc8Hvzxdv8hy
         k0VXeU8XJyHed3aF1jokZCNbjDXRu8+eo6E4Gjuj+YBx4wgpzje7M/zaQ1BLDQK9a0oq
         wYQIVfL4TFE7DONblNfLkpcNex8hk5FPRRs2o=
MIME-Version: 1.0
In-Reply-To: <4A748A48.8020702@gmail.com>
References: <h51hro$p6j$1@ger.gmane.org> <4A748A48.8020702@gmail.com>
Date: Sat, 1 Aug 2009 17:44:08 -0500
X-Google-Sender-Auth: 2fa4464241457456
Message-ID: <cdb43e8a0908011544o69c2203dv39ce5a04840e0869@mail.gmail.com>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
From: Jack Byer <ojbyer@usa.net>
To: Robert Hancock <hancockrwd@gmail.com>, Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you post the dmesg output from detecting the device?

I was originally getting this error:

irq 3: nobody cared (try booting with the "irqpoll" option)
Pid: 23488, comm: modprobe Not tainted 2.6.31-rc4 #2
Call Trace:
[<c104e3f4>] ? __report_bad_irq+0x24/0x90
[<c104e5b7>] ? note_interrupt+0x157/0x1a0
[<c104edcb>] ? handle_level_irq+0xbb/0x100
[<c1004ec7>] ? handle_irq+0x17/0x20
[<c100490a>] ? do_IRQ+0x3a/0xb0
[<c1003329>] ? common_interrupt+0x29/0x30
[<c10284b5>] ? __do_softirq+0x35/0xf0
[<c104d4ed>] ? handle_IRQ_event+0x2d/0xc0
[<c102859d>] ? do_softirq+0x2d/0x40
[<c102874d>] ? irq_exit+0x5d/0x80
[<c1004913>] ? do_IRQ+0x43/0xb0
[<c1003329>] ? common_interrupt+0x29/0x30
[<c104dc0a>] ? __setup_irq+0x17a/0x2c0
[<f80fa7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
[<c104de11>] ? request_threaded_irq+0xc1/0x100
[<c104f2c4>] ? devm_request_threaded_irq+0x34/0xa0
[<f80fa7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
[<c104f2ee>] ? devm_request_threaded_irq+0x5e/0xa0
[<f80e9c3f>] ? ata_host_activate+0x8f/0x110 [libata]
[<f80fa7f0>] ? ata_sff_interrupt+0x0/0xf0 [libata]
[<f99a6466>] ? pcmcia_init_one+0x2c6/0x340 [pata_pcmcia]
[<c10c8e81>] ? sysfs_find_dirent+0x21/0x30
[<f8359a26>] ? pcmcia_device_probe+0xf6/0x1b0 [pcmcia]
[<c10c9fa1>] ? sysfs_do_create_link+0xa1/0x140
[<c1155b24>] ? driver_probe_device+0x74/0x180
[<f835a0eb>] ? pcmcia_bus_match+0x1bb/0x4a0 [pcmcia]
[<c1155cb1>] ? __driver_attach+0x81/0x90
[<f83597b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
[<c1155474>] ? bus_for_each_dev+0x54/0x80
[<f83597b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
[<c11559c6>] ? driver_attach+0x16/0x20
[<c1155c30>] ? __driver_attach+0x0/0x90
[<c1154d06>] ? bus_add_driver+0xb6/0x250
[<f83597b0>] ? pcmcia_device_remove+0x0/0x140 [pcmcia]
[<c1155f27>] ? driver_register+0x67/0x150
[<f835ab51>] ? pcmcia_register_driver+0x91/0x110 [pcmcia]
[<f99ab000>] ? pcmcia_init+0x0/0xa [pata_pcmcia]
[<c100102a>] ? _stext+0x2a/0x160
[<c104b3c3>] ? sys_init_module+0xb3/0x1f0
[<c1081ca1>] ? sys_read+0x41/0x80
[<c1002cf4>] ? sysenter_do_call+0x12/0x26
handlers:
[<f80fa7f0>] (ata_sff_interrupt+0x0/0xf0 [libata])
Disabling IRQ #3

Now I rebooted with irqpoll and everything looks good in dmesg:

yenta_cardbus 0000:00:0a.0: CardBus bridge found [103c:0024]
yenta_cardbus 0000:00:0a.0: O2: res at 0x94/0xD4: 00/ea
yenta_cardbus 0000:00:0a.0: O2: enabling read prefetch/write burst
yenta_cardbus 0000:00:0a.0: ISA IRQ mask 0x00b8, PCI irq 11
yenta_cardbus 0000:00:0a.0: Socket status: 30000007 pcmcia_socket
pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x200-0x207
0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3c0-0x3d2: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3d4-0x3df: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x1000-0x17ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia 0.0: pcmcia: registering new device pcmcia0.0
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0x100 ctl 0x10e irq 3
ata3.01: both IDENTIFYs aborted, assuming NODEV
ata3.00: CFA: IBM-DMDM-10340, MD2IC501, max PIO1
ata3.00: 700560 sectors, multi 0: LBA
ata3.00: configured for PIO0
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access ATA IBM-DMDM-10340 MD2I PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 700560 512-byte logical blocks: (358 MB/342 MiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg2 type 0
   sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk

Now my transfer rate has increased to 20 kilobyte / second read, about
4 times faster than before but still pretty slow.
