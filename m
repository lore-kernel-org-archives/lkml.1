Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbXESUeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbXESUeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbXESUd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:33:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:22690 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbXESUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jQwea8cSpkb7UFl7ne4H1mkd0A4GRXWsP14d8k/zWktxXnUvycvBGBbzjHwBSHRqgVWvuh60RRXP9OytSah6cV4VauDmt22jYJW3Qrh9qjh2h8t3YioWGuGUst8FB/Cu8etDAJBHY/95tzqADWRa55S1LEx7OnxajR59YsQ2pjs=
Message-ID: <b637ec0b0705191333y63440c45ld8be4c02b2d329d7@mail.gmail.com>
Date: Sat, 19 May 2007 22:33:58 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: radeonfb and X800 cards
Cc: "Luca Tettamanti" <kronos.it@gmail.com>, "Daniel Drake" <dsd@gentoo.org>,
       "linux list" <linux-kernel@vger.kernel.org>, Jimmy.Jazz@gmx.net
In-Reply-To: <1179451612.32247.329.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
	 <20070517195958.GA6489@dreamland.darkstar.lan>
	 <b637ec0b0705171329i6da89fa8h655976e823aef41e@mail.gmail.com>
	 <1179451612.32247.329.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
This patch does not work for me.
Relevant part of the dmesg output is:

< ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
< radeonfb: Reference=27.00 MHz (RefDiv=7) Memory=330.00 Mhz, System=358.00 MHz
< Device driver i2c-0 lacks bus and class support for being resumed.
< Device driver i2c-1 lacks bus and class support for being resumed.
< Device driver i2c-2 lacks bus and class support for being resumed.
< Device driver i2c-3 lacks bus and class support for being resumed.
< i2c-adapter i2c-2: unable to read EDID block.
< i2c-adapter i2c-2: unable to read EDID block.
< i2c-adapter i2c-2: unable to read EDID block.
<  * Connector 1 is Internal Panel. Head 0, Monitor: LVDS Flat panel
(EDID probed)
<    ddc port: 0, dac: -1, tmds: -1
<  * Connector 2 is VGA. Head -1, Monitor: None
<    ddc port: 2, dac: 0, tmds: -1
< radeonfb: detected LVDS panel size from BIOS: 1280x800
< radeonfb: Dynamic Clock Power Management enabled
< radeonfb (0000:01:00.0): ATI Radeon VS

My card is:

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon
Mobility X700 (PCIE) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company Unknown device 309e
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at d0000000 (32-bit, prefetchable) [size=128M]
        I/O ports at 3000 [size=256]
        Memory at c8100000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at c8120000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint IRQ 0
        Capabilities: [80] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
        Capabilities: [100] Advanced Error Reporting

Please let me know if you need more details.
Regards,
Fabio




On 5/18/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Thu, 2007-05-17 at 22:29 +0200, Fabio Comolli wrote:
>
> > Is there a reason why this patch can't go upstream?
>
> Yes. A change of that magnitude will most certainly introduce
> regressions. So we can either:
>
>  - Have it in -mm for monthes trying to iron out all of them (and we'll
> miss some). And struggle also since it's hard to track subtle
> regressions with very big patches.
>
>  - Have it split in smaller bits, which make it possible to bisect in
> case of problem, and thus find/correct problems much faster.
>
> That's my main issue with it at this point. But I'm ok going for route
> #1 provided that you guys are willing to help with tracking regressions
> down. That also mean I need to do some serious testing on powermacs
> since those rely very heavily on a working radeonfb.
>
> Ben.
>
>
>
