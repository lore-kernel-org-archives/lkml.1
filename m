Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZKAVHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZKAVHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZKAVHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:07:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZKAVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:07:00 -0500
Date: Sun, 1 Nov 2009 22:06:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091101210609.GD18116@pengutronix.de>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 23, 2009 at 10:38:43PM +0200, Uwe Kleine-König wrote:
> This fixes several things while still providing the old API:
> 
>  - simplify and fix locking
>  - better error handling
>  - don't ack all irqs making it impossible to detect a reset of the
>    rtc
>  - use a timeout variant to wait for completion of ADC conversion
>  - provide platform-data to regulator subdevice (This allows making
>    struct mc13783 opaque for other drivers after the regulator driver is
>    updated to use its platform_data.)
>  - expose all interrupts
>  - use threaded irq
> 
> After all users in mainline are converted to the new API, some things
> (e.g. mc13783-private.h) can go away.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/mc13783-core.c          |  789 ++++++++++++++++++++++++-----------
>  include/linux/mfd/mc13783-private.h |  208 +---------
>  include/linux/mfd/mc13783.h         |  122 +++++--
>  3 files changed, 651 insertions(+), 468 deletions(-)
I havn't received feedback yet for this patch.

I'd like to start updating the regulator driver, but only when I now my
updates here are considered sensible.

As this is a rewrite, reading the patch might not be that easy.  So if
you only want to see the new version, you can find it at

	http://git.pengutronix.de/?p=ukl/linux-2.6.git;a=blob;f=drivers/mfd/mc13783-core.c;h=63a5104bf2ea83be817587f83a53beaabd418a6b;hb=e49c74fa5001b54632b704deb837e98bc5b307c0

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
