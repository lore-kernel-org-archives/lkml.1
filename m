Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXCaKhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXCaKhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXCaKhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:37:34 -0400
Received: from khc.piap.pl ([195.187.100.11]:49863 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbXCaKhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:37:22 -0400
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: Mikko Tiihonen <mikko.tiihonen@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
References: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
	<1175294288.32441.6.camel@rousalka.dyndns.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 31 Mar 2007 12:37:20 +0200
In-Reply-To: <1175294288.32441.6.camel@rousalka.dyndns.org> (Nicolas Mailhot's message of "Sat, 31 Mar 2007 00:38:08 +0200")
Message-ID: <m3bqi9u2an.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Mailhot <nicolas.mailhot@laposte.net> writes:

> Oh, is looks so close to my system
>
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
> 00: de 10 50 00 0f 00 a0 00 a3 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
>                 ^^^^^^^^^^^
>                 Usual HPET base address
> 50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
> 60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
> 70: 10 00 ff ff c1 00 00 00 00 00 04 19 18 d2 80 0d
>                 ^^
>                 c1 => HPET disabled (according to your reference)
>
> I don't have an HPET toggle in my bios

For reference: HPET enabled in BIOS, MSI K9N platinum board:

dmesg | grep HPET
ACPI: HPET (v001 A M I  OEMHPET0 0x02000701 MSFT 0x00000097)
	@ 0x000000003ffd5480
ACPI: HPET id: 0x10de8201 base: 0xfed00000
time.c: Using 25.000000 MHz WALL HPET GTOD HPET timer.

00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
        Subsystem: Micro-Star International Co., Ltd. Unknown device 7250
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 2f00 [size=128]
00: de 10 62 03 0f 00 a0 00 a2 00 01 06 00 00 80 00
10: 01 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 50 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 62 14 50 72 00 00 d0 fe fa 3e ff 00 fa 3e ff 00
                ^^^^^^^^^^^
Dword at 0x44 indeed seems to be the address

50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 fe 3f
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 ff
70: 10 00 ff ff c5 80 00 00 00 00 45 19 00 c6 40 00
                ^^
Enabled = consistent with http://lkml.org/lkml/2006/12/17/69

80: 09 20 00 10 1d 08 00 00 f0 00 00 01 f0 00 00 00
90: 00 08 00 00 00 00 00 00 21 47 95 86 ef cd ab 00
a0: 01 00 00 81 00 00 00 00 00 00 00 00 00 00 00 00
             ^^
Not sure about 0xa3, though.

b0: 00 00 00 00 00 0a 7f 0a 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 44 00 00 fe fd d3 00 a0
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00
-- 
Krzysztof Halasa
