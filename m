Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXJISup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXJISup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXJISuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:50:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:60157 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbXJISuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:50:23 -0400
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
	<470BC0D5.70305@freescale.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Oct 2007 20:50:19 +0200
In-Reply-To: <470BC0D5.70305@freescale.com> (Timur Tabi's message of "Tue, 09 Oct 2007 12:56:37 -0500")
Message-ID: <m3fy0kcec4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> Yeah, I read that article some time ago when trying to diagnose the
> problem I was seeing.  It does explain the point I'm trying to make.
> We have a device that's used on two product lines: one ARM-based, and
> one PowerPC.  The ARM is little-endian, and the PowerPC is big-endian.
> The device can support little-endian or big-endian data, as long as
> the bit-order matches the byte-order.

There is no such thing as bit-order. The data lines are numbered,
say, D0 - D31, with D0 being LSB (bit) and D31 MSB.

You usually write register bits from MSB to LSB, so shift left
increments and shift right decrements the value. This is orthogonal
to the big/little-endianness.

Now your device can be connected straight to the bus or the data
lanes (4 on 32-bit PCI) can be crossed. This is platform-dependent.
The kernel provides functions/macros to access devices in
a independent way, such as writel/readl/pci_map_* etc.
-- 
Krzysztof Halasa
