Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZHKN5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZHKN5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZHKN5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:57:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55775 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZHKN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:57:48 -0400
Date: Tue, 11 Aug 2009 15:57:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [RFC] Freescale MC13783 PMIC support
Message-ID: <20090811135748.GR6108@pengutronix.de>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <20090811140500.2678b289.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811140500.2678b289.ospite@studenti.unina.it>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:57:57 up 6 days, 17 min, 40 users,  load average: 0.12, 0.23,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

On Tue, Aug 11, 2009 at 02:05:00PM +0200, Antonio Ospite wrote:
> On Tue, 11 Aug 2009 11:07:42 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Hi all,
> > 
> > This series adds support for the Freescale MC13783 PMIC. The MC13783
> > is connected via SPI, the first patch adds basic support for it in
> > drivers/mfd. The rest of the patches can be applied independently.
> > Individual Maintainers are on Cc, the whole series can be found on
> > lkml and the Arm Linux Kernel mailing list.
> > Please ignore the previous mail which lacked the intrductory mail.
> > 
> > Sascha
> >
> 
> Hi Sascha,
> 
> the MC13783 is also named Atlas, isn't it?
> Maybe you can add this name somewhere in comments or in Kconfig entry
> to help greppers and web crawlers.
> 
> BTW, I only took a very brief look to some of your patches, and here's
> some humble thoughts, sorry if I don't comment patch by patch.
> 
> There is a driver queued for inclusion in 2.6.31 for the PCAP2
> PMIC, which is quite similar to MC13783. This driver uses the irq_chip
> mechanism to expose the PMIC IRQs to be used as general IRQs in
> sub-devices drivers (which you call client-devices AFAICS).

I can change the driver if there's consensus to do so.

> Also, it
> passed all the reviews so maybe you can give it a look to take some
> other solution already accepted by reviewers, like passing sub-devices
> via platform data (some of the phones which use PCAP2 don't have
> touchscreen, for instance),

This is indeed a useful feature. What I don't like about the pcap
approach is that the generation of the correct struct pcap_subdev
devices with the correct names is left to the board code.
Maybe we can also use the flags approach I already started with
MC13783_USE_TOUCHSCREEN which can be passed to the platform_data?

> generalize the driver so to handle multiple
> PMICs in one system (quite unlikely scenario?),

All functions take a struct mc13783 * so I think it should work with
multiple PMICs already.

> read actual pressure
> in TS driver.

This is left as an exercise for people who have the hardware which
supports this feature ;)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
