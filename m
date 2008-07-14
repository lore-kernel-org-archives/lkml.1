Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYGNUoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYGNUoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYGNUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:44:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYGNUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:44:16 -0400
Date: Mon, 14 Jul 2008 13:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net,
       piotr.skamruk@gmail.com, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH] Add SPI over GPIO driver
Message-Id: <20080714134345.a2287c6c.akpm@linux-foundation.org>
In-Reply-To: <200807142109.13243.mb@bu3sch.de>
References: <200807142109.13243.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 21:09:12 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> +static inline void do_spidelay(struct spi_device *dev, unsigned nsecs)
> +{
> +	struct spi_gpio *sp = spidev_to_sg(dev);
> +
> +	if (!sp->info->no_spi_delay)
> +		ndelay(nsecs);
> +}
> +
> +#define spidelay(nsecs) do {					\
> +	/* Steal the spi_device pointer from our caller.	\
> +	 * The bitbang-API should probably get fixed here... */	\
> +	do_spidelay(spi, nsecs);				\
> +  } while (0)

A macro which requires that its caller have a particular local variable
is a bit nasty.  Could we plan to add the spi_device* to spidelay()
please? 
