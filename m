Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYK1JXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYK1JXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK1JXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:23:43 -0500
Received: from host4.kei.pl ([195.149.226.213]:59295 "EHLO smtp.host4.kei.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYK1JXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:23:42 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2008 04:23:41 EST
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <marcin@haerwu.biz>
To: Akinobu Mita <akinobu.mita@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] progear_bl: use platform_device_register_simple()
Date: Fri, 28 Nov 2008 10:17:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc4; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20080921143827.GF8790@localhost.localdomain>
In-Reply-To: <20080921143827.GF8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811281017.17809.marcin@haerwu.biz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 21 of September 2008 16:38:29 Akinobu Mita napisał(a):
> This change also fixes error handling when platform_device_alloc()
> fails. (When platform_device_alloc() failed, it returns error without
> unregistering progearbl_driver)
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Marcin Juszkiewicz <linux@hrw.one.pl>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Marcin Juszkiewicz <marcin@haerwu.biz>

> ---
>  drivers/video/backlight/progear_bl.c |   20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>
> Index: 2.6-git/drivers/video/backlight/progear_bl.c
> ===================================================================
> --- 2.6-git.orig/drivers/video/backlight/progear_bl.c
> +++ 2.6-git/drivers/video/backlight/progear_bl.c
> @@ -119,20 +119,16 @@ static int __init progearbl_init(void)
>  {
>  	int ret = platform_driver_register(&progearbl_driver);
>
> -	if (!ret) {
> -		progearbl_device = platform_device_alloc("progear-bl", -1);
> -		if (!progearbl_device)
> -			return -ENOMEM;
> -
> -		ret = platform_device_add(progearbl_device);
> -
> -		if (ret) {
> -			platform_device_put(progearbl_device);
> -			platform_driver_unregister(&progearbl_driver);
> -		}
> +	if (ret)
> +		return ret;
> +	progearbl_device = platform_device_register_simple("progear-bl",
> -1, +								NULL, 0);
> +	if (IS_ERR(progearbl_device)) {
> +		platform_driver_unregister(&progearbl_driver);
> +		return PTR_ERR(progearbl_device);
>  	}
>
> -	return ret;
> +	return 0;
>  }
>
>  static void __exit progearbl_exit(void)


Regards, 
-- 
JID:      hrw@jabber.org
Website:  http://blog.haerwu.biz/
LinkedIn: http://www.linkedin.com/in/marcinjuszkiewicz


