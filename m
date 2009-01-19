Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZASR1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZASR1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbZASR0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:26:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbZASRZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:25:59 -0500
Date: Mon, 19 Jan 2009 18:25:36 +0100
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
Message-ID: <20090119172536.GA12407@pengutronix.de>
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com> <20090119100342.GA16400@pengutronix.de> <45a44e480901190619i18749c75jaa2d4606da251921@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45a44e480901190619i18749c75jaa2d4606da251921@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: Re: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

> >> +[OPTIONAL] Spinlock-Safe GPIO Batch access
> > Is it really spinlock safe in general?  Or only if gpio_cansleep(gpio)
> > if false for each gpio to get or set?
> 
> You are correct to raise this issue. It is only spinlock safe if
> chip->cansleep is false. Initially, I wasn't sure what to do. The
> original gpio set/get_value() just does;
>         WARN_ON(extra_checks && chip->can_sleep);
> and it is documented as:
> 
> "
> Spinlock-Safe GPIO access
> -------------------------
> <snip>
> return zero.  Also, using these calls for GPIOs that can't safely be accessed
> without sleeping (see below) is an error.
> "
> 
> I will change this in the batch code to return an error if can_sleep
> is detected on any involved gpio_chip.
Wait, I got it wrong.  I thought gpio_set_value might sleep if
chip->cansleep is true, but there are extra API functions for
cansleep-chips.  So I'd do it the same way as for the non-batch
functions and just WARN_ON(extra_checks && chip->cansleep) for each
involved chip.

Later it might make sense to add the _cansleep variants.

Best regards
Uwe
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
