Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbYHEPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbYHEPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbYHEPAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:00:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62287 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164AbYHEPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NwEwB8xUEs35B41GrKzcwA3X44W4mgIFyVBc1nS4YEp6Ex1otaEaqLwlzilnjdRMtJ
         TKwBHIhqeaQJoJKHAFztg2hdpLaYipdhErsLIRQoHWPxVhufhUqYoPzyqwcVTKpa1drU
         WBMJ3/59ZsFH6nEISQh1Gu6VrgCmgtD9DV8KA=
Message-ID: <3f9a31f40808050800h7073b82al1342f7e23cf1e1b3@mail.gmail.com>
Date: Tue, 5 Aug 2008 20:30:10 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/dev/ttyS1 and /dev/ttyS2 of NetMos Technology PCI 9835 is giving Junk
characters in minicom but /dev/tyS0 is working perfectly.

01:01.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O
Controller (rev 01)
	Subsystem: LSI Logic / Symbios Logic 1P2S
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at dc00 [size=8]
	Region 1: I/O ports at d480 [size=8]
	Region 2: I/O ports at d400 [size=8]
	Region 3: I/O ports at d080 [size=8]
	Region 4: I/O ports at d000 [size=8]
	Region 5: I/O ports at df00 [size=16]
	Kernel driver in use: parport_serial

[jsr@jaswinder 0000:01:01.0]$ setserial /dev/ttyS0 -a
/dev/ttyS0, Line 0, UART: 16550A, Port: 0x03f8, IRQ: 4
	Baud_base: 115200, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal skip_test

[jsr@jaswinder 0000:01:01.0]$ setserial /dev/ttyS1 -a
/dev/ttyS1, Line 1, UART: 16550A, Port: 0xdc00, IRQ: 22
	Baud_base: 115200, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal skip_test

[jsr@jaswinder 0000:01:01.0]$ setserial /dev/ttyS2 -a
/dev/ttyS2, Line 2, UART: 16550A, Port: 0xd480, IRQ: 22
	Baud_base: 115200, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal skip_test

[jsr@jaswinder 0000:01:01.0]$ setserial /dev/ttyS3 -a
/dev/ttyS3, Line 3, UART: unknown, Port: 0x02e8, IRQ: 3
	Baud_base: 115200, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal auto_irq

from dmesg :
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Switched to high resolution mode on CPU 0
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
parport_serial 0000:01:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
parport1: PC-style at 0xd400 [PCSPP(,...)]
0000:01:01.0: ttyS1 at I/O 0xdc00 (irq = 22) is a 16550A
0000:01:01.0: ttyS2 at I/O 0xd480 (irq = 22) is a 16550A


Thank you,

Jaswinder Singh.
