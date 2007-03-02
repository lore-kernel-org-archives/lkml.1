Return-Path: <linux-kernel-owner+w=401wt.eu-S1422931AbXCBGAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931AbXCBGAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422930AbXCBGAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:00:15 -0500
Received: from za-gw.sanpeople.com ([196.211.225.226]:4180 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbXCBGAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:00:14 -0500
Subject: Re: [patch 2.6.20-rc2] gpio_direction_output() needs an initial
	value
From: Andrew Victor <andrew@sanpeople.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Milan Svoboda <msvoboda@ra.rockwell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <200703011825.10370.david-b@pacbell.net>
References: <200703011825.10370.david-b@pacbell.net>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1172814491.26751.4.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 02 Mar 2007 07:48:12 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi David,

> It's been pointed out that output GPIOs should have an initial value, to
> avoid signal glitching ... among other things, it can be some time before
> a driver is ready.  This patch corrects that oversight, fixing

For the AT91 changes:
  Acked-by: Andrew Victor <andrew@sanpeople.com>


> --- g26.orig/drivers/spi/atmel_spi.c	2007-02-28 12:47:43.000000000 -0800
> +++ g26/drivers/spi/atmel_spi.c	2007-03-01 15:29:30.000000000 -0800

> -		gpio_direction_output(npcs_pin);
> +		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
>  	}

As mentioned previously (by Walter Tuppa), wouldn't it be better to just
change this to:
     cs_deactivate(spi);


Regards,
  Andrew Victor


