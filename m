Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXJ2MxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXJ2MxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXJ2MxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:53:06 -0400
Received: from khc.piap.pl ([195.187.100.11]:33475 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXJ2MxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:53:05 -0400
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
	<m3ejfp4bg9.fsf@maximus.localdomain>
	<4724C9DA.7030900@s5r6.in-berlin.de>
	<m33avvdlbq.fsf@maximus.localdomain>
	<47251744.6090206@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 29 Oct 2007 13:53:01 +0100
In-Reply-To: <47251744.6090206@s5r6.in-berlin.de> (Stefan Richter's message of "Mon, 29 Oct 2007 00:12:04 +0100")
Message-ID: <m3abq2ccb6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> This device is a somewhat buggy PCI card which somebody sent me after
> unsuccessful attempts to get it properly working under Linux.  Among
> more serious trouble, ohci1394 reads a bogus maximum async payload (a
> zero value) from the BusOptions register during startup.  This has
> occasionally been reported for some VT6306 in the past.  I haven't
> really tested this card myself yet, it's currently stuck in a PC which I
> don't use anymore.

I see. I think you may be able to cure this problem with my program,
adding corrected values in addition to write to 0x11 should do the
trick. 93c46 is 16-bit, little-endian here. You'd have to divide the
addresses shown by the dump by 2 of course.
I'd make sure the values are ok before rebooting, there is some
possibility a badly corrupted EEPROM may prevent BIOS from starting.

I think I'd leave GUID (16-bit words at 0, 1, 2, 3) and PCI subsystem
IDs (words at 0xA and 0xB) unchanged, and for all other locations I'd
fill in the 6307 values.

Of course I don't know if the program will be able to write to VT6306,
so I'd test the broken card first.

> VT6306 CardBus card in my main PC:
> MMIO=[80000000-800007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
> ieee1394: Host added: ID:BUS[2-00:1023]  GUID[00110600000041cc]

The difference is of course at 0x0E, not 0x1E. Maybe the byte at 0x0A
is 0x92 for 4 IR contents and 0xA2 for 8 contents. That would also
make sense wrt the broken 6306 as it has 0x00 there.
-- 
Krzysztof Halasa
