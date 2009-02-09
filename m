Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZBILyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZBILyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZBILyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:54:09 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:33472 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388AbZBILyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:54:08 -0500
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver - revised
Date: Mon, 9 Feb 2009 12:53:57 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
References: <20090113015904.606e3548.akpm@linux-foundation.org> <200901261418.19681.wolfgang.mues@auerswald.de> <20090208204452.0ecdb18e@mjolnir.drzeus.cx>
In-Reply-To: <20090208204452.0ecdb18e@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902091253.57594.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre,

Am Sonntag, 8. Februar 2009 schrieb Pierre Ossman:
> Please split these things up into one patch for each item. It keeps the
> logs sensible and makes bisecting work better in case of problems.

OK. I will do.

> > +	/*
> > +	 * The MMC framework does a good job of computing timeouts
> > +	 * according to the mmc/sd standard. However, we found that in
> > +	 * SPI mode, there are many cards which need a longer timeout
> > +	 * of 1s after receiving a long stream of write data.
> > +	 */
> > +	tv = ktime_to_timeval(timeout);
> > +	if (tv.tv_sec == 0)
> > +		timeout = ktime_set(1, 0);
> >
> >  	if (host->mmc->use_spi_crc)
> >  		scratch->crc_val = cpu_to_be16(
>
> This might as well be handled when we compute the timeout in the core.
> Having things spread out is just confusing.

Hmmm. Inside the core, this timeout value will be calculated as:

timeout = 250ms;
if (driver == SPI)
   timeout = 1s;

I agree that it is confusing to have the timeout value set on two places.
Do you prefer to have it set in the mmc core, different for SPI and non-SPI?

> > -	if (host->mmc->use_spi_crc) {
> > +	/*
> > +	 * Omit the CRC check for CID and CSD reads. There are some SDHC

> Hmmm... I think this also better handled in the core. Reorder things in
> the init to not turn CRC checks on until after those registers have
> been read.

No! CRC checks are ONLY disabled for CID and CSD reads, NOT for the reading of 
data blocks. And I don't want to set use_spi_scc == 0 because I don't want to 
disable the safety of CRC for data blocks.

regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
