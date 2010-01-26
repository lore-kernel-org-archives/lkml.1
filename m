Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0AZQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0AZQNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734Ab0AZQNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:13:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57993 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752477Ab0AZQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:13:21 -0500
Date: Tue, 26 Jan 2010 16:13:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126161319.GX15759@rakim.wolfsonmicro.main>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260535.21689.david-b@pacbell.net>
 <20100126142102.GU15759@rakim.wolfsonmicro.main>
 <201001260744.46780.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001260744.46780.david-b@pacbell.net>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 07:44:46AM -0800, David Brownell wrote:
> On Tuesday 26 January 2010, Mark Brown wrote:

> > In the sort of design I'm talking about there is generally a system
> > power rail which is generated from the various power sources available
> > to the system, which might include a combination of batteries, USB and
> > wall adaptors.

> Just as an example:  drivers/mfd/tps6510.c supports exactly
> that trio of power sources.

Yup, it's a fairly standard feature set for all in one PMICs, WM835x and
WM831x are also examples of this.

>                              More than one system rail though,
> which (as you know) is pretty common -- core != I/O.

Yes, in this context the system rail is the supply input to the
regulators rather than the regulated voltages that are (mostly)
used directly by the chips.

> Bus powered devices can come up on that 100mA, running
> enough to enumerate ... and request more power, if they
> need it.

> Not all Linux systems can boot with that little power!

Some can even brown themselves out going full pelt with the full 500mA
supply if there's no battery to supplement it :/
