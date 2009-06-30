Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZF3P5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZF3P5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZF3P5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:57:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44481 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZF3P53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:57:29 -0400
Date: Tue, 30 Jun 2009 16:57:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
	and use it for olpc driver
Message-ID: <20090630155713.GG13961@sirena.org.uk>
References: <20090630021730.44f86185@mycelium.queued.net> <20090630113135.GD13961@sirena.org.uk> <20090630110430.6c7c5cdf@mycelium.queued.net> <20090630153719.GA13300@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630153719.GA13300@oksana.dev.rtsoft.ru>
X-Cookie: Only fools are quoted.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 07:37:19PM +0400, Anton Vorontsov wrote:
> On Tue, Jun 30, 2009 at 11:04:30AM -0400, Andres Salomon wrote:

> > As far as the slow type, I don't see the need either, but I assumed
> > Anton was aware of devices that differentiated between slow and
> > trickle charging.

> Yep, there are two charging modes in Openmoko Neo FreeRunners:

> - 100 mA. It's "slow" mode -- used when the Neo couldn't negotiate
>   with USB host, so it is permitted to only draw 100 mA from VBUS.

I strongly suspect you will find that the "slow" mode there is actually
a trickle charge.  It's a lot more practical to trickle charge in mobile
phone sized systems since the batteries are so much smaller than laptop
batteries.  

> - 500/1000 mA. It's so-called "fast" mode, can be enabled after
>   successful negotiation with the USB host.

Even if the 500mA is available you'll not always be able to do a fast
charge from a USB supply - some systems draw enough current to require
that the USB supply be suppliemented from battery when they're being
heavily used.

> Well, this kind slow charging isn't official terminology, and
> I'm not sure if we should use it. But I'm fine with it since we
> can always remove "Slow" mode (i.e. report it as "Fast"), and
> userspace won't break.

I guess my main question was if it was distinguishable from trickle
charging.
