Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZG1PA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZG1PA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZG1PA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:00:56 -0400
Received: from d1.icnet.pl ([212.160.220.21]:48326 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZG1PAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:00:55 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant CX20442-11 voice modem codec
Date: Tue, 28 Jul 2009 16:59:33 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200907220522.29221.jkrzyszt@tis.icnet.pl> <20090722101027.GA7622@sirena.org.uk>
In-Reply-To: <20090722101027.GA7622@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281659.36000.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday 22 July 2009 12:10:28 Mark Brown wrote:
> On Wed, Jul 22, 2009 at 05:22:28AM +0200, Janusz Krzysztofik wrote:
> > This patch adds support for Conexant CX20442-11 voice modem codec,
> > suitable for use by the ASoC board driver for Amstrad E3 (Delta)
> > videophone. Related sound card driver will follow.
> >
> You'll want to run checkpatch over it and send a followup fixing the
> issues it identifies.  Looking at this I suspect that it may be possible
> to refactor things so that more of the line discipline interaction is
> pushed down into the CODEC driver but that can also be done as a
> followup.
>
> would also be nice to add some documentation somewhere explaining how
> the hw_write() function is expected to be set up since it's a little
> surprising (if the line discipline stuff were pushed down into the code
> that'd become a lot more obvious).

Mark,
I am ready with a followup that corrects those minor issues, as well as with a 
new, corrected version of the machine driver. However, before I submit them, 
I'd like to discuss again your idea of pushing down the line discipline code 
into the codec driver.

As you may have noticed, my codec driver was ready for adopting it to one or 
more additional buses of different types, in a way similiar to those 
implemented in other codec drivers. There was a room for a hypothetical 
cx20442_xxx_probe() function, invoked by a hypothetical xxx bus driver after 
the bus comes up or a device is detected on it. That function could then set 
up its own codec->control_data and codec->hw_write pointers for talking to 
the codec via a hypothetical xxx bus adapter using its write method. In 
particular, that could be a line discipline provided acceess to the codec 
assosociated modem.

Following that model, the line discipline code didn't seam to belong to a 
codec driver for me. If it could be recognized as a new bus dirver, it should 
be pushed down probably into a separate module. However, if it was rather 
some kind of a bus adapter driver, it seamed to belong to the machine code.

As I had got no positive feedback to my RFC on inventing a new bus (votes were 
rather neutral, and I agreed with them[1]), I decided to put the line 
discipline code into the machine driver.

If you see things somehow different, please let me know, I can try to follow 
your ideas and rearrange the code.

Cheers,
Janusz

[1] http://www.spinics.net/lists/linux-serial/msg01856.html
