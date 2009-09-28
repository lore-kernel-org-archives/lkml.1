Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZI1MWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZI1MWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 08:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZI1MWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 08:22:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44783 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZI1MWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 08:22:10 -0400
Date: Mon, 28 Sep 2009 13:22:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com, cbou@mail.ru,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       utx@penguin.cz, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, eric.y.miao@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: something wrong in drivers/power
Message-ID: <20090928122210.GB32420@sirena.org.uk>
References: <20090926095555.GG1331@ucw.cz> <20090926145536.GA8445@doriath.ww600.siemens.net> <20090927173516.GB6710@elf.ucw.cz> <20090928075517.GA6871@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928075517.GA6871@doriath.ww600.siemens.net>
X-Cookie: Please come again.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 11:55:17AM +0400, Dmitry Eremin-Solenikov wrote:

> 1) add a clean possibility to pass platform data via ac97 bus to wm97xx
> core driver (care to check that it should be passable both via regular
> ac97 driver and via ASoC).

This has already been done by Marek, I think most of the bits made it
into 2.6.32-rc1 though I haven't checked.  The problem had been getting
ALSA support for using the platform data but Takashi agreeded to that so
we're fine.  It needs explict support in the AC97 controller driver to
actually set the platform data for the CODECs on the bus but that's been
done for PXA.

In any case, I'd nack the original patch too - all it will do is break
the driver since it will no longer load and the attempts to get the
wm97xx structure from the parent device of a separately registered
platform device will oops.
