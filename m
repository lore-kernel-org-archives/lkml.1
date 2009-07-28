Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZG1Qgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZG1Qgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZG1Qgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:36:45 -0400
Received: from d1.icnet.pl ([212.160.220.21]:36952 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZG1Qgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:36:44 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant CX20442-11 voice modem codec
Date: Tue, 28 Jul 2009 18:36:01 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200907220522.29221.jkrzyszt@tis.icnet.pl> <200907281807.31070.jkrzyszt@tis.icnet.pl> <20090728161131.GA22349@rakim.wolfsonmicro.main>
In-Reply-To: <20090728161131.GA22349@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281836.03049.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday 28 July 2009 18:11:32 Mark Brown wrote:
> On Tue, Jul 28, 2009 at 06:07:29PM +0200, Janusz Krzysztofik wrote:
> > now. Activation of the line discipline would deregister the codec device
> > from the platform bus and reregister it again, now as the line discipline
> > provided device. Is this possible with current ASoC framework?
>
> No, not currently.  But why would you do that, anyway?
>
> Like I say, I'd suggest always keeping the controls registered and just
> masking and unmasking from user space - the control indexes get used so
> removing them will just confuse things.

However, in order for the machine driver to unmask/mask a machine specific 
control, the codec driver must drop the machine driver a message about the 
line discipline being activeted/deactivated, right? The only such existing 
feedback I can see the codec is able to use is via snd_soc_init_card() that 
calls snd_soc_dai_link.init() in turn. Am I missing something?

Janusz
