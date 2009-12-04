Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZLDMpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZLDMpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZLDMpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:45:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50545 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZLDMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:45:02 -0500
Date: Fri, 4 Dec 2009 12:45:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-ID: <20091204124505.GA3320@sirena.org.uk>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it> <20091202180658.GA12292@rakim.wolfsonmicro.main> <20091204133943.ddf0e53d.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204133943.ddf0e53d.ospite@studenti.unina.it>
X-Cookie: Happy feast of the pig!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 01:39:43PM +0100, Antonio Ospite wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > You almost certainly want regulator_get_exclusive() here; this driver
> > can't function properly if something else is using the regulator and
> > holding the LED on or off without it.  You'll also want to check the
> > status of the LED on startup and update your internal status to match
> > that.

> When you refer to "the status of the LED on startup" do you mean a
> initial brightness value passed via leds-regulator platform data, or the
> initial status or the regulator itself?

The hardware state at startup; I would imagine that you'd want to make
setting the initial state via platform data optional in order to enable
a smooth handover from bootloader to Linux where the state may depend on
the runtime state (eg, charging indication).
