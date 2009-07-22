Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZGVMTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZGVMTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZGVMT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:19:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48469 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751040AbZGVMT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:19:27 -0400
Date: Wed, 22 Jul 2009 13:19:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>, alsa-devel@alsa-project.org,
       Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad
 E3 (Delta) machine
Message-ID: <20090722121925.GE21171@rakim.wolfsonmicro.main>
References: <200907220523.01107.jkrzyszt@tis.icnet.pl>
 <20090722110328.GB7622@sirena.org.uk>
 <s5hhbx50wwl.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbx50wwl.wl%tiwai@suse.de>
X-Cookie: Biology grows on you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 01:39:22PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > > +	/* Setup pins after corresponding bits if changed */
> > > +	if ((bool)snd_soc_dapm_get_pin_status(codec, "Speaker") !=
> > > +			(bool)(function & (1 << AMS_DELTA_SPEAKER))) {

> > Don't like these casts...  why are they needed?

> Because the right side is the bit operation?

Ick, yes.

> The cast doesn't look nice, though...

Indeed.  I'd suggest rewriting to try to do less in the if statement - a
helper function seems to be in order here since the same code is
repeated several times with different pins and bitmasks.
