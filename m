Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZFXJYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZFXJYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZFXJYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:24:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43301 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZFXJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:24:42 -0400
Date: Wed, 24 Jun 2009 11:24:43 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       Andrea Paterniani <a.paterniani@swapp-eng.it>
Subject: Re: [PATCH 1/2] remove i.MX SPI driver
Message-ID: <20090624092443.GW31396@pengutronix.de>
References: <1245308072-14392-1-git-send-email-s.hauer@pengutronix.de> <1245308072-14392-2-git-send-email-s.hauer@pengutronix.de> <20090623155840.c750b70b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623155840.c750b70b.akpm@linux-foundation.org>
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
X-Uptime: 11:10:22 up 43 days, 23:34, 37 users,  load average: 0.04, 0.09,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:58:40PM -0700, Andrew Morton wrote:
> On Thu, 18 Jun 2009 08:54:31 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > This driver is in a non working state at the moment and will
> > be replaced by a bitbang driver which can also handle the
> > newer i.MX variants
> 
> hum.  How did it get into a non-working state?
> 
> From the logs, it looks like it was working OK for Andrea Paterniani
> when he patched it in April last year.

The driver was written for arch-imx which is superseeded by arch-mxc
now. It depends on the i.MX DMA API which changed while moving from
arch-imx to arch-mxc.
A reason to keep the old driver is that it has DMA support, but Andrea
agrees that it's better to add DMA support to the new driver than to fix
it in the old driver.

> 
> Ordinarily I'd be asking whether this replacement of one driver with
> another is a 100% seamless change.  But I guess that the audience for
> SPI drivers are sufficiently technical to be able to handle the odd
> Kconfig changes, module parameter changes, module name changes, etc.
> 
> But I do think that if there are any such user-visible changes, they
> should be described in the changelog.  And I think there are such
> changes - the module name at least?
> 
> 
> Is it possible and desirable to retain both drivers for a while?  Would
> that ease the transition?  It also gives people a fallback driver to
> use, if your new driver doesn't work for them.  Just like eepro100.c,
> which lived for five years ;)

I rather try to avoid that. Note that this is a platform driver which
had zero inkernel users till now.

> 
> But it's really hard to make any decisions about this because the
> changelog failed to provide any details about the "non working state".
>

I'll add notes about this to the patch which removes the driver.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
