Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYIDD7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYIDD7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 23:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYIDD7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 23:59:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1142 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYIDD7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 23:59:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Panin <pazke@donpac.ru>
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Date: Wed, 3 Sep 2008 21:59:30 -0600
User-Agent: KMail/1.9.9
Cc: Chris Bergeron <chris@pcburn.com>, linux-kernel@vger.kernel.org,
       kyle@xtechgear.com
References: <20071010095432.GC30345@pazke.donpac.ru> <471CDA66.2020004@pcburn.com> <20071028154242.GA13166@pazke.donpac.ru>
In-Reply-To: <20071028154242.GA13166@pazke.donpac.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032159.30778.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2007 9:42:42 am Andrey Panin wrote:
> On 295, 10 22, 2007 at 01:14:14 -0400, Chris Bergeron wrote:
> > Andrey Panin wrote:
> >> On 291, 10 18, 2007 at 01:00:06 -0400, Chris Bergeron wrote:
> >>   So the card probably generates screaming interrupt... that's bad.
> >> I found some docs for IT887x chips, according to these docs  IT887x
> >> have simple interrupt controller inside. Further investigation is
> >> needed.

Can you point me to any of those IT887x docs?  I haven't been able
to dig any up myself.

> Can you test an attached patch against 2.6.24-rc1 ?

I tested basically the same patch against a current upstream tree,
and the syba ports don't work, even with "irqpoll".  Here's the
discovery:

Serial: 8250/16550 driver16 ports, IRQ sharing enabled
<FF>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
00:10: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:10: driver attached
00:11: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial 00:11: driver attached
serial 0000:00:01.0: check 0x2a0
serial 0000:00:01.0: got 0x0
serial 0000:00:01.0: syba at 0x000002a0
serial 0000:00:01.0: ite887x: io base at 0x2a0
serial 0000:00:01.0: ite887x: IRR0=00 IMR0=00 IER0=00
serial 0000:00:01.0: ite887x: IRR1=00 IMR1=00 IER1=00
serial 0000:00:01.0: ite887x: IRR2=00 IMR2=00 IER2=00
0000:00:01.0: ttyS4 at I/O 0x1000 (irq = 16) is a 16550A
0000:00:01.0: ttyS5 at I/O 0x1008 (irq = 16) is a 16550A
0000:00:01.0: ttyS6 at I/O 0x1010 (irq = 16) is a 16550A
0000:00:01.0: ttyS7 at I/O 0x1018 (irq = 16) is a 16550A
0000:00:01.0: ttyS8 at I/O 0x1020 (irq = 16) is a 16550A
0000:00:01.0: ttyS9 at I/O 0x1028 (irq = 16) is a 16550A
0000:00:01.0: ttyS10 at I/O 0x1030 (irq = 16) is a 16550A
0000:00:01.0: ttyS11 at I/O 0x1038 (irq = 16) is a 16550A

The entire dmesg log is at http://helgaas.com/tmp/sybase.txt
The patch I tested is at http://helgaas.com/tmp/sybase.patch

Here's the "lspci -xxx" output:

00:01.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev 01)
00: b5 10 16 90 03 01 80 02 01 02 00 07 00 00 00 00
10: 01 10 00 00 d1 10 00 00 c1 10 00 00 00 30 24 e8
20: 00 20 24 e8 00 10 24 e8 00 00 00 00 4e 54 08 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: 3f 3f 08 00 00 8c 20 8b 45 54 55 45 00 00 10 d2
50: 01 01 71 03 01 03 00 00 00 00 00 00 00 00 00 00
60: a0 02 00 e5 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 a0 02 00 00 f8 03 f8 02
80: 78 03 78 07 00 08 00 07 00 01 20 01 40 01 60 01
90: 00 00 00 00 00 00 00 00 00 00 00 00 70 43 25 64
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
