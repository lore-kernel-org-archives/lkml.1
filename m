Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZHKM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZHKM2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZHKM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:28:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32911 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZHKM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:28:46 -0400
Date: Tue, 11 Aug 2009 13:28:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [RFC] Freescale MC13783 PMIC support
Message-ID: <20090811122842.GG24947@sirena.org.uk>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <20090811140500.2678b289.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811140500.2678b289.ospite@studenti.unina.it>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 02:05:00PM +0200, Antonio Ospite wrote:
> Sascha Hauer <s.hauer@pengutronix.de> wrote:

> There is a driver queued for inclusion in 2.6.31 for the PCAP2
> PMIC, which is quite similar to MC13783. This driver uses the irq_chip
> mechanism to expose the PMIC IRQs to be used as general IRQs in
> sub-devices drivers (which you call client-devices AFAICS). Also, it

Use of the generic IRQ infrastructure in I2C/SPI MFDs is a bit dodgy at
this point - it can be persuaded to work but genirq really doesn't
support it properly since it wants to run with interrupts disabled but
you want interrupts for these slower buses.  It's likely to get resolved
but right now it's safer to work outside the framework in order to avoid
surprises.

> passed all the reviews so maybe you can give it a look to take some
> other solution already accepted by reviewers, like passing sub-devices
> via platform data (some of the phones which use PCAP2 don't have
> touchscreen, for instance), generalize the driver so to handle multiple

There's also the wm831x drivers which do all the subdevice stuff via the
MFD core and are prepared for a transition to genirq once devices like
this are actively supported by it.

> PMICs in one system (quite unlikely scenario?), read actual pressure

It's vanishingly unlikely that you'd see two Atlases in one system - you
might see two PMICs but not two primary PMICs with stuff like battery
chargers on them.
