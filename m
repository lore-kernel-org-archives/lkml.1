Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbXJ1RmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbXJ1RmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXJ1RmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:42:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37986 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXJ1RmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:42:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4724C9DA.7030900@s5r6.in-berlin.de>
Date: Sun, 28 Oct 2007 18:41:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de>	<m3fy09ffp9.fsf@maximus.localdomain>	<4719A0C4.3050301@s5r6.in-berlin.de>	<m3bqausztv.fsf@maximus.localdomain>	<4719FF0F.3080504@s5r6.in-berlin.de> <m3ejfp4bg9.fsf@maximus.localdomain>
In-Reply-To: <m3ejfp4bg9.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Ok. I just put a program on something like
> http://www.kernel.org/~chris/vt6307ohciver.c
> 
> Anybody with OHCI-1.0 VT6307* Firewire chip may want to try. Obviously
> it's based on undocumented features, it may blow your machine etc.
> 
> Please remove your ohci1394 or firewire-ohci driver before using this
> program.
> 
> Compile with the usual spell: gcc -Wall -O2 vt6307ohciver.c -o vt6307ohciver

I also had to specify "-lpci" on Mandrake 10.1, "-lpci -lz" on Gentoo.

...
> If you have a VT6306-based card and you run this program, I'd
> appreciate it if you let me know the EEPROM contents (make sure
> you mention chip type)

	# lspci|grep 1394
	00:0a.3 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394
	Host Controller (rev 46)
	00:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394
	Host Controller (rev 46)

These are both VT6306, one on the motherboard and one on a PCI card.

	# ./a.out 00:0a.3
	I/O region #1 is at C800
	It seems your VT6307 chip is connected to 93c46 EEPROM
	Page size is 4096 (0x1000) bytes
	GUID PROM register address is 0xec101004
	Mapping 8 (0x8) bytes of memory at 0xec101000
	Mapped mem region #0 at virtual address 0xb7f3a000
	GUID PROM register is at virtual address 0xb7f3a004

	EEPROM dump:
	00: 00 11 06 00 00 00 E3 32 00 88 00 08 44 00 00 00
	10: A1 E4 2F 00 06 11 44 30 03 DF 40 00 00 20 00 73
	20: 3C 10 00 00 00 00 FF FF FF FF FF FF D7 57 55 75

	Your VT6307 chip is in OHCI 1.0 mode

	# ./a.out 00:0c.0
	I/O region #1 is at D000
	It seems your VT6307 chip is connected to 93c46 EEPROM
	Page size is 4096 (0x1000) bytes
	GUID PROM register address is 0xec103004
	Mapping 8 (0x8) bytes of memory at 0xec103000
	Mapped mem region #0 at virtual address 0xb7f1a000
	GUID PROM register is at virtual address 0xb7f1a004

	EEPROM dump:
	00: 00 30 1B AC 00 00 2B A4 04 04 32 55 F8 00 A2 02
	10: A1 00 40 63 06 11 44 30 03 DF 40 00 00 20 00 73
	20: 3C 10 00 00 00 00 FF FF FF FF FF FF FF FF FF FF

	Your VT6307 chip is in OHCI 1.0 mode


On another PC:

	# lspci | grep 1394
	02:02.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2
	IEEE-1394b Link Layer Controller (rev 01)
	05:04.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394
	Host Controller (rev 80)
	06:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394
	Host Controller (rev 46)

The "rev 80" chip is a VT6307 on the motherboard.

	# ./a.out 05:04.0
	I/O region #1 is at ED00
	It seems your VT6307 chip is connected to I^2C (24c01 or
	similar) EEPROM
	Page size is 4096 (0x1000) bytes
	GUID PROM register address is 0xfbffd004
	Mapping 8 (0x8) bytes of memory at 0xfbffd000
	Mapped mem region #0 at virtual address 0xb7f76000
	GUID PROM register is at virtual address 0xb7f76004

	EEPROM dump:
	00: 00 10 DC 56 00 FE D2 D4 04 04 32 55 F8 00 A2 02
	10: A1 00 40 63 20 63 62 14 03 DF 40 80 00 20 00 73
	20: 3C 10 08 00 00 00 FF FF FF FF FF FF FF FF FF FF

	Your VT6307 chip is in OHCI 1.1 mode

The "rev 46" chip is on a CardBus card.  So far I believed it to be a
VT6306 but I can't easily open the card's casing...

	# ./a.out 06:00.0
	I/O region #1 is at E000
	It seems your VT6307 chip is connected to I^2C (24c01 or
	similar) EEPROM
	Page size is 4096 (0x1000) bytes
	GUID PROM register address is 0x80000004
	Mapping 8 (0x8) bytes of memory at 0x80000000
	Mapped mem region #0 at virtual address 0xb7f2f000
	GUID PROM register is at virtual address 0xb7f2f004

	EEPROM dump:
	00: 00 11 06 00 00 00 41 CC 04 04 32 55 F8 00 92 02
	10: A1 00 40 63 06 11 44 30 03 DF 40 80 00 20 00 73
	20: 3C 10 00 00 00 00 A0 00 FF FF FF FF FF FF FF FF

	Your VT6307 chip is in OHCI 1.0 mode

> and, if you tried "upgrading" or "downgrading", if it worked.

I haven't tried it yet.
-- 
Stefan Richter
-=====-=-=== =-=- ===--
http://arcgraph.de/sr/
