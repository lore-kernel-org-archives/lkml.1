Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZGaVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZGaVoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZGaVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:44:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45769 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZGaVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:44:07 -0400
Date: Fri, 31 Jul 2009 22:44:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20090731214401.GC6335@sirena.org.uk>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
 <20090731172002.GA32578@rakim.wolfsonmicro.main>
 <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
 <b90c0690907311332o958b7f4nd025aa7a8b273a88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b90c0690907311332o958b7f4nd025aa7a8b273a88@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage
 regulator driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 11:32:32PM +0300, Roger Quadros wrote:

> Not having gpio_get_direction() in gpiolib is a limitation I think.
> Can we just do the following for now ? (i.e. disable regulator by default)
> Will there be any glitch? If yes, then how?

If you're going to do this then like I say you should make the default
state controllable by platform data.  If we unconditionally disable the
regulator then if, for example, the regulator is controlling the display
backlight and it's on when Linux get controls then the user will see the
backlight blink off then on during startup.
