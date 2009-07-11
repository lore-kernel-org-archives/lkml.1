Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZGKW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZGKW0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZGKW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:26:18 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:53512 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZGKW0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:26:17 -0400
Message-ID: <4A59117B.6020309@f2s.com>
Date: Sat, 11 Jul 2009 23:26:03 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, Antonino Daplas <adaplas@gmail.com>,
       Alberto Mardegan <mardy@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move w100fb's probe function to .devinit.text
References: <20090711170548.GC5205@suse.de> <1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-39-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-40-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-41-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-42-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-42-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Ian Molton <ian@mnementh.co.uk>

Uwe Kleine-König wrote:
> A pointer to w100fb_probe is passed to the core via
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
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: Alberto Mardegan <mardy@users.sourceforge.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/w100fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
> index 2376f68..5d22395 100644
> --- a/drivers/video/w100fb.c
> +++ b/drivers/video/w100fb.c
> @@ -628,7 +628,7 @@ static int w100fb_resume(struct platform_device *dev)
>  #endif
>  
>  
> -int __init w100fb_probe(struct platform_device *pdev)
> +int __devinit w100fb_probe(struct platform_device *pdev)
>  {
>  	int err = -EIO;
>  	struct w100fb_mach_info *inf;

