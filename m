Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXJUCaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXJUCaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXJUCaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:30:00 -0400
Received: from khc.piap.pl ([195.187.100.11]:34770 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXJUC37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:29:59 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
	<4719A0C4.3050301@s5r6.in-berlin.de>
	<m3bqausztv.fsf@maximus.localdomain>
	<4719FF0F.3080504@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 21 Oct 2007 01:23:50 +0200
In-Reply-To: <4719FF0F.3080504@s5r6.in-berlin.de> (Stefan Richter's message of "Sat, 20 Oct 2007 15:13:51 +0200")
Message-ID: <m3ejfp4bg9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I just put a program on something like
http://www.kernel.org/~chris/vt6307ohciver.c

Anybody with OHCI-1.0 VT6307* Firewire chip may want to try. Obviously
it's based on undocumented features, it may blow your machine etc.

Please remove your ohci1394 or firewire-ohci driver before using this
program.

Compile with the usual spell: gcc -Wall -O2 vt6307ohciver.c -o vt6307ohciver

Examine (and backup) the EEPROM data first:

# /sbin/lspci | grep 1394
01:04.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
	Controller (rev 80)

# ./vt6307ohciver 01:04.0
[some debug info]
It seems your VT6307 chip is connected to I^2C (24c01 or similar) EEPROM

EEPROM dump:
00: 00 10 DC 00 01 01 D4 F2 04 04 32 55 F8 00 A2 02
10: A1 00 40 63 62 14 0D 25 03 DF 40 80 00 20 00 73
20: 3C 10 00 00 00 00 FF FF FF FF FF FF FF FF FF FF
          ^^
Your VT6307 chip is in OHCI 1.0 mode

(If you have only one VIA firewire chip you can use "" as the argument.)

I'd check if there is a small SMD 8-pin 24c01 or similar EEPROM
near VT6307 if I were you. Alternatively the program may say you
have 93c46, also a small 8-pin chip.

Now you can try upgrading to OHCI-1.1:

# ./vt6307ohciver "" 1.1
It seems your VT6307 chip is connected to I^2C (24c01 or similar) EEPROM
writing 0x08 at address 0x22
Please reboot

People with 93c46 will see 0x11 address.

Do as commanded, reboot (PCI reset) is required for the VT6307 to reload
the configuration from its EEPROM.


Please let me know if it doesn't work.


This program may possibly run on VT6306-based board/card as well,
though I don't know what would happen (I suspect it could work,
but may need some modifications).

The "dump" function should work with any OHCI firewire device,
though for non-VIA chips you would have to change PCI device/vendor
ID in the source.

If you have a VT6306-based card and you run this program, I'd
appreciate it if you let me know the EEPROM contents (make sure
you mention chip type) and, if you tried "upgrading" or
"downgrading", if it worked. In theory VT6306 should be able to
run in OHCI-1.1 mode, but I don't really know.
VT6306 only supports 93c46 EEPROM so if the program says 24c01
you may want to force it (edit the source) and let me know.

VT6305 users may not bother, this chip doesn't support OHCI-1.1.
Not sure if anything like it ever existed, though.
-- 
Krzysztof Halasa
