Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYANQgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYANQgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYANQfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:35:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53985 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbYANQfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:35:54 -0500
Date: Mon, 14 Jan 2008 16:35:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode
	on PXA2xx systems
Message-ID: <20080114163552.GA26436@rakim.wolfsonmicro.main>
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
	Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>, Ian Molton <spyro@f2s.com>,
	Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com> <478B31B6.3050406@pengutronix.de> <20080114144250.GA7443@rakim.wolfsonmicro.main> <478B7A86.7010207@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B7A86.7010207@pengutronix.de>
X-Cookie: FORTH IF HONK THEN
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 04:06:46PM +0100, Marc Kleine-Budde wrote:
> Mark Brown wrote:
> > On Mon, Jan 14, 2008 at 10:56:06AM +0100, Marc Kleine-Budde wrote:

> > The driver really isn't intended to cope with them.  As you say, other
> > boards may have things wired up differently and therefore require
> > different configuration of the wm97xx and other bits of the system.  The
> > expectation is that other systems will have their own driver.

> What bits have to setup in a different way? Only the stuff in
> wm97xx_acc_startup() or other things aswell. An irq can be put as utual

The main thing for pxa2xx would be the interrupt enable callback and
possibly also the acc_shutdown() function depending on what the startup
function had to do for the board.  If there were platform data then at
least some of the module options (AC97 link slot, for example) ought to
have at least defaults supplied that way too.  However...

> into a device's resouce, Setting up bits may be done like other stuff on
> pxa, too. e.g. pxa_set_ohci_info.

It's straightforward for something discovered using the platform bus but
unfortunately these controllers are AC97 devices and are discovered via
the AC97 bus.  This makes life harder - I can't see any sensible way of
getting platform data to describe the machine to the driver.  Hopefully
I'm missing something here but if not the options are limited.

> With my limited understanding of the pxa-wm97xx.c file, the only board
> dependent stuff is done in wm97xx_acc_startup() so a different "driver"
> for other boards would result in code duplication.

That's a concern I share - you'll likely end up with either that or
ifdefs, neither of which is ideal.  Being able to use platform data
would be much nicer for all these drivers, not just pxa2xx-wm97xx.
