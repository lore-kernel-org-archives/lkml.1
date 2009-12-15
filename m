Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZLOFoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZLOFoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZLOFoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:44:11 -0500
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:30507 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751569AbZLOFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:44:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ewmGV3wpPXMLssmDt6GsEt/DZgJdMfJCBmFFmT4cFYG8XF9OwmL65kMQWxd7nW6zBd8GUU99aQOB3cc7v1olq5O/9j6z70fBMjHCfxPOPCkXy2jw+5bebcFgrL4IvJ2ZUIHVA9FNjpy3CZT5gUw3tLjPq5qm2hmF5+EBE1vYobA=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: 5ZXTnGAVM1lzvgt1i2sPBEKZXkboAVC1TWlzEhZMrncq06X_1QLQc4rB_ZWqDr6oFNMR6NHnOvviP_kKJm74UrU83DVJWYzip_NjwplFo1tWloNZ6s4J6fF1M5hJFOU.tWpIYbDBRNKcK.vkc.xCwuku8bA5KwbrWBsv0xwtwyKpyh0u7ehyO1grfs6zrUwB6qi7J2pX5ZRMekXkRpT24iNBOmMzDAZZYPi.n_Ci.EPfQH6O2Jnhupq82RiU_3CT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] mmc: move regulator handling to core
Date: Mon, 14 Dec 2009 21:44:08 -0800
User-Agent: KMail/1.9.10
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Cliff Brake <cbrake@bec-systems.com>,
       "Lavinen Jarkko \(Nokia-D/Helsinki\)" <jarkko.lavinen@nokia.com>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de> <4B181BB4.1020800@nokia.com> <20091204115805.GS14091@buzzloop.caiaq.de>
In-Reply-To: <20091204115805.GS14091@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912142144.08591.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Daniel Mack wrote:
> On Thu, Dec 03, 2009 at 10:12:36PM +0200, Adrian Hunter wrote:
> > Daniel Mack wrote:
> > >On Thu, Dec 03, 2009 at 04:27:39PM +0200, Adrian Hunter wrote:
> 
> > >>What about arch/arm/mach-omap2/mmc-twl4030.c ?
> > >
> > >Argh, missed that one. And this particular case doesn't fit to my
> > >modifications. I don't know the code well ...  We would need to
> > >have a struct mmc_host * in all the functions there calling
> > >mmc_regulator_{set,get}_ocr. Any idea how to resolve that?

Finish separating the HSMMC setup from the OMAP2 setup, then the
HSMMC stuff will be a lot easier to cope with.  The HSMMC stuff
is never used with the mfd/menelaus transceiver/slot switch stuff;
including those data structures caused lots of hassles.

The only real issue with the HSMMC stuff is that it's got to continue
working with the many wiring options now in use.


> Moving the regulator handling to the mmc core would require a major
> cleanup to all this code, but I don't have such hardware to test my
> modifications. Can anyone help here?

Simplest to borrow a Beagle.  Make sure whatever you do
can handle both standard SDHC cards, and also 8-bit HSMMC.
Once that works, the rest will fall out pretty easily.

- Dave
