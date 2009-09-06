Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZIFW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZIFW3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZIFW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 18:29:22 -0400
Received: from dan.rpsys.net ([93.97.175.187]:61333 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbZIFW3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 18:29:21 -0400
Subject: Re: Zaurus suspend saga
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
In-Reply-To: <20090906052653.GB1324@ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 23:29:05 +0100
Message-Id: <1252276145.17852.15.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 07:26 +0200, Pavel Machek wrote:
> fatal reads invalid values -- -108 -- probably because spi is not ready?
> 
> is spi suspend/resume required? yes.; and yes spi is resumed too late
>  in the sequence. Or perhaps fatal battery check is way too early.
> 
> Could someone confirm that simply removing sharpsl_fatal_check() fixes
> zaurus suspend on 2.6.31? 

Sadly lack of time means I've lost track of the Zaurus kernels but this
sounds like all accesses to the SSP buses now go through the SPI layer
and when it was converted nobody thought about the impact this would
have on the Zaurus charger code.

If suspend/resume is broken in this way, it also means the charger code
is also likely to be totally broken/malfunctioning since it won't be
able to read from the ADC either.

Either:

a) Someone steps up and finds a way to partially resume the kernel so
the "offline" charging code can work and access SPI
b) We find some other way to allow the SPI interface to be accessed by
the charger code without resuming the whole kernel (the way it used to
work)
c) We rip the whole thing out and stop supporting "offline" charging.

I'd hate to see c) happen but I doubt I'm going to find time to rewrite
that code any time soon and nobody else even seems to have grasped how
deep this problem really is :(.

Richard

