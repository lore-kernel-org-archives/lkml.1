Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZAYLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZAYLVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZAYLU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:20:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZAYLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:20:58 -0500
Date: Sun, 25 Jan 2009 12:20:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [RFC 2.6.28 1/3] gpiolib: add batch set/get
Message-ID: <20090125112024.GA28213@pengutronix.de>
References: <123287728936-git-send-email-jayakumar.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <123287728936-git-send-email-jayakumar.lkml@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jaya,

On Sun, Jan 25, 2009 at 05:54:47PM +0800, Jaya Kumar wrote:
> - split the patches into generic, arch specific and am300epd
I would swap the order to have:

	generic
	am300epd
	pxa specific

This way the tree of the second commit is a test case for the generic
implementation.

> - adjusting the API to remove width (note, the actual API call where
>   width was dropped is in the arch specific code, not here.)
Nevertheless I would document the "generic" per arch specific
implementation in gpio.txt.  For the functions like __gpio_get_value you
can just do

	#define gpio_get_value(gpio) __gpio_get_value(gpio)

but for your batch functions you need something like

	#define gpio_set_batch(startpin, mask, values) \
		({ u32 __mask = mask; __gpio_set_batch(startpin, __mask, fls(__mask), values);})

Maybe better use/recommend an inline function?

> Cc: David Brownell <david-b@pacbell.net>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: linux-fbdev-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-embedded@vger.kernel.org
> Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Note you didn't Cc: me.

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
