Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZG1QIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZG1QIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZG1QIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:08:20 -0400
Received: from d1.icnet.pl ([212.160.220.21]:60679 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZG1QIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:08:17 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant CX20442-11 voice modem codec
Date: Tue, 28 Jul 2009 18:07:29 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200907220522.29221.jkrzyszt@tis.icnet.pl> <200907281659.36000.jkrzyszt@tis.icnet.pl> <20090728150727.GA10870@rakim.wolfsonmicro.main>
In-Reply-To: <20090728150727.GA10870@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281807.31070.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday 28 July 2009 17:07:27 Mark Brown wrote:
> On Tue, Jul 28, 2009 at 04:59:33PM +0200, Janusz Krzysztofik wrote:
> > Following that model, the line discipline code didn't seam to belong to a
> > codec driver for me. If it could be recognized as a new bus dirver, it
> > should be pushed down probably into a separate module. However, if it was
> > rather some kind of a bus adapter driver, it seamed to belong to the
> > machine code.
>
> The way it looks with the current code the line discipline itself is
> going to apply equally well to any serial port that's used - I'm not
> clear what's system-specific about it.  The bit that connects the line
> discipline to the line is a different matter but the bit that interacts
> with the TTY layer after registration is working through a pluggable
> abstraction layer and shouldn't, I'd expect, be specific to the
> particular serial port.

Mark,
I think I can't tell anything more before I try to implement it in a way you 
suggest, so I will.

What I would like to retain from the current codec driver are those two modes 
of operation: without and with the line discipline activated. Initially, the 
codec would be registered as a platform device, as it is now. Activation of 
the line discipline would deregister the codec device from the platform bus 
and reregister it again, now as the line discipline provided device. Is this 
possible with current ASoC framework?

Thanks,
Janusz
