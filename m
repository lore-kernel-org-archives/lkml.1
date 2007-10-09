Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXJIWMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXJIWMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXJIWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:12:04 -0400
Received: from khc.piap.pl ([195.187.100.11]:54714 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbXJIWMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:12:01 -0400
To: Timur Tabi <timur@freescale.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
	<4706A842.9030507@freescale.com>
	<20071009174623.GC4003@csclub.uwaterloo.ca>
	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>
	<470BCEFC.9060302@freescale.com> <m37ilwcc4v.fsf@maximus.localdomain>
	<470BDA3A.1060809@freescale.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 10 Oct 2007 00:11:59 +0200
In-Reply-To: <470BDA3A.1060809@freescale.com> (Timur Tabi's message of "Tue, 09 Oct 2007 14:44:58 -0500")
Message-ID: <m38x6cc500.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> I think when the PowerPC is running in little-endian mode, that might
> be the case.  It needs to be able to write a byte in big-endian mode,
> and then read that byte back in little-endian mode and have it be the
> same byte.

But this is exactly what excludes changing bit orders :-)

There are other CPU types which can work both LE and BE.
If you write 0x12345678 and switch endianness you get 0x78563412,
but the individual bits are still in the same (natural) order.

In the kernel, to convert from BE to LE or vice versa you need
something like swab32 (assuming 32-bit ints). It doesn't change
the order of the individual bits, it only swaps the (4 in this case)
bytes ("lanes" for hw swapping, PCI etc).

If you, for example, write an 8-bit integer in BE mode and want
it back in LE mode, you have to XOR the address with 0x3, but
the value already comes in the same natural bit order. Of course
swab32 will do as well.
-- 
Krzysztof Halasa
