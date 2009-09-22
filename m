Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbZIVEBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbZIVEBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbZIVEBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:01:32 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57778 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZIVEBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NYbrTWqAdWYd/izWptnO3UTXoGt33gSdU9pNK0Mu9N0Jp8ED48DiqXWT9wfm8jC3Vi
         MMfG04BNGkHE4l1soSH8M1TurwEAbD9LbcBCdmOoj1uWbSsbmynsLEnJT5Oqz/hHv0gS
         J+txwxLhxHl58CFCKF41pwGY2JNF3weInTCXc=
MIME-Version: 1.0
Date: Mon, 21 Sep 2009 21:01:34 -0700
Message-ID: <55a4f86e0909212101s3097a1e3yf225f3e165ff0bea@mail.gmail.com>
Subject: libATA SATA errors on DVD bad sectors...
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following on bad sectors on a pretty badly scratched DVD:

Sep 21 20:23:20 zeus kernel: ata12.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x6
Sep 21 20:23:20 zeus kernel: ata12.00: port_status 0x20280000
Sep 21 20:23:20 zeus kernel: ata12.00: cmd
a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2048 in
Sep 21 20:23:20 zeus kernel:         cdb a8 00 00 16 02 6c 00 00  00
01 00 00 00 00 00 00
Sep 21 20:23:20 zeus kernel:         res
51/30:03:00:00:00/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
Sep 21 20:23:20 zeus kernel: ata12.00: status: { DRDY ERR }
Sep 21 20:23:20 zeus kernel: ata12: hard resetting link
Sep 21 20:23:21 zeus kernel: ata12: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Sep 21 20:23:21 zeus kernel: ata12.00: configured for UDMA/100
Sep 21 20:23:21 zeus kernel: ata12: EH complete

Sep 21 20:23:24 zeus kernel: ata12.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x6
Sep 21 20:23:24 zeus kernel: ata12.00: port_status 0x20280000
Sep 21 20:23:24 zeus kernel: ata12.00: cmd
a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2048 in
Sep 21 20:23:24 zeus kernel:         cdb a8 00 00 16 02 6d 00 00  00
01 00 00 00 00 00 00
Sep 21 20:23:24 zeus kernel:         res
51/30:03:00:00:00/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
Sep 21 20:23:24 zeus kernel: ata12.00: status: { DRDY ERR }
Sep 21 20:23:24 zeus kernel: ata12: hard resetting link
Sep 21 20:23:24 zeus kernel: ata12: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Sep 21 20:23:25 zeus kernel: ata12.00: configured for UDMA/100
Sep 21 20:23:25 zeus kernel: ata12: EH complete

The command being run is:
sg_dd blk_sgio=1 bpt=1 bs=2048 cdbsz=12 coe=0 coe_limit=0 if=/dev/srX
odir of=badsector.bin count=1 skip=$i

on a Fedora 11 box:
Linux zeus 2.6.30.5-43.fc11.x86_64 #1 SMP Thu Aug 27 21:39:52 EDT 2009
x86_64 x86_64 x86_64 GNU/Linux

These only seem to show up when the DVD is inserted into /dev/sr1.
/dev/sr0 doesn't seem to spew this crap (although both drives fail to
read the sector).

/sys/block/sr0 ->
../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sr0
/sys/block/sr1 ->
../devices/pci0000:00/0000:00:1e.0/0000:03:09.0/host11/target11:0:0/11:0:0:0/block/sr1

ata1.00: HL-DT-ST BD-RE GGW-H20L YL05 UDMA/133
ata12.00: LITE-ON DVDRW LH-20A1L BL06 UDMA/100

# lspci [-n] | egrep '1e.0|1f.2|3:09'
00:1f.2 0106: 8086:2922 SATA controller: Intel Corporation
82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1e.0 0604: 8086:244e PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
03:09.0 0180: 105a:3d17 Mass storage controller: Promise Technology,
Inc. PDC40718 (SATA 300 TX4) (rev 02)

ie. the Lite-On drive on the promise TX4 controller has issues, while
the LG on the intel AHCI controller seems fine...

Would it make sense to add this somewhere into the code as a 'bad
sector' error condition and not perform a hard reset?

It may be worth pointing out that the LiteOn drive is significantly
faster in dealing with the bad sectors, and actually successfully
reads a far larger number of them (about 15% of the sectors that the
LG can't read, the Lite-On can, and in about 2/3 of the time).  I
would guess that if it didn't have to hard reset the bus, it'd be even
faster...

- Maciej
