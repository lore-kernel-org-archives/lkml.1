Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0BDVYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:24:39 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:53660 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0BDVYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:24:36 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 16:24:36 EST
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Eric Miao <eric.miao@marvell.com>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/9] platform-drivers: move probe to .devinit.text in arch/arm
References: <20100203150850.GA28815@kroah.com>
	<1265313417-5568-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: RtpNet
Date: Thu, 04 Feb 2010 22:20:26 +0100
In-Reply-To: <1265313417-5568-1-git-send-email-u.kleine-koenig@pengutronix.de> ("Uwe
 =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Thu\,  4 Feb 2010 20\:56\:49
 +0100")
Message-ID: <878wb8wvdx.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> A pointer to a probe callback is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> Cc: Paul Sokolovsky <pmiscml@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/mach-pxa/corgi_ssp.c           |    2 +-
>  arch/arm/mach-pxa/sharpsl_pm.c          |    2 +-
>  arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
>  arch/arm/mach-sa1100/jornada720_ssp.c   |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

For the h1940-bluetooth change :
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>

