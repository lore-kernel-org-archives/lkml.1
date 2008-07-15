Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYGOMw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYGOMw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYGOMwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:52:51 -0400
Received: from bu3sch.de ([62.75.166.246]:46366 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbYGOMwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:52:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add SPI over GPIO driver
Date: Tue, 15 Jul 2008 14:52:13 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net,
       piotr.skamruk@gmail.com, openwrt-devel@lists.openwrt.org
References: <200807142109.13243.mb@bu3sch.de> <20080714134345.a2287c6c.akpm@linux-foundation.org>
In-Reply-To: <20080714134345.a2287c6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151452.13573.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 22:43:45 Andrew Morton wrote:
> On Mon, 14 Jul 2008 21:09:12 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > +static inline void do_spidelay(struct spi_device *dev, unsigned nsecs)
> > +{
> > +	struct spi_gpio *sp = spidev_to_sg(dev);
> > +
> > +	if (!sp->info->no_spi_delay)
> > +		ndelay(nsecs);
> > +}
> > +
> > +#define spidelay(nsecs) do {					\
> > +	/* Steal the spi_device pointer from our caller.	\
> > +	 * The bitbang-API should probably get fixed here... */	\
> > +	do_spidelay(spi, nsecs);				\
> > +  } while (0)
> 
> A macro which requires that its caller have a particular local variable
> is a bit nasty.  Could we plan to add the spi_device* to spidelay()
> please? 


Yeah right. I was planning to fix this later on _after_ this was merged.
This makes the merge easier with less patch cross-dependencies.


-- 
Greetings Michael.
