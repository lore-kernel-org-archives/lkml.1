Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZGVKKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZGVKKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZGVKKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:10:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57236 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZGVKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:33 -0400
Date: Wed, 22 Jul 2009 11:10:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant
	CX20442-11 voice modem codec
Message-ID: <20090722101027.GA7622@sirena.org.uk>
References: <200907220522.29221.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907220522.29221.jkrzyszt@tis.icnet.pl>
X-Cookie: One size fits all.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 05:22:28AM +0200, Janusz Krzysztofik wrote:
> This patch adds support for Conexant CX20442-11 voice modem codec, suitable
> for use by the ASoC board driver for Amstrad E3 (Delta) videophone. Related
> sound card driver will follow.

> Created and tested against linux-2.6.31-rc3.
> Applies and works with linux-omap-2.6 commit
> 7c5cb7862d32cb344be7831d466535d5255e35ac as well.

> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

This patch is basically fine from an ASoC point of view so I've applied
it.

You'll want to run checkpatch over it and send a followup fixing the
issues it identifies.  Looking at this I suspect that it may be possible
to refactor things so that more of the line discipline interaction is
pushed down into the CODEC driver but that can also be done as a
followup.

Since this (and all the other descriptive text that follows it):

> This codec is an optional part of the Conexant SmartV three chip modem design.
> As such, documentation for its proprietary digital audio interface is not
> available. However, on Amstrad Delta board, thanks to Mark Underwood who

...is useful documentation I've pulled it into the commit message.  It
would also be nice to add some documentation somewhere explaining how
the hw_write() function is expected to be set up since it's a little
surprising (if the line discipline stuff were pushed down into the code
that'd become a lot more obvious).
