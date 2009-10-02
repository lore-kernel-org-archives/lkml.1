Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZJBIBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZJBIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZJBIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:01:19 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:6328 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZJBIBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:01:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC5B34E.3080903@tremplin-utc.net>
Date: Fri, 02 Oct 2009 10:01:18 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: akpm@linux-foundation.org, daniel@caiaq.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] LIS3LV02D_SPI: Module unload didn't remove sysfs
 entry
References: <1254399924-30921-1-git-send-email-samu.p.onkalo@nokia.com> <1254399924-30921-2-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1254399924-30921-2-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-10-09 14:25, Samu Onkalo schreef:
> In module unload, lis3lv02d core driver sysfs clean up was not called.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> Acked-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>


> ---
>  drivers/hwmon/lis3lv02d_spi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
> index ecd7395..82b1680 100644
> --- a/drivers/hwmon/lis3lv02d_spi.c
> +++ b/drivers/hwmon/lis3lv02d_spi.c
> @@ -83,7 +83,8 @@ static int __devexit lis302dl_spi_remove(struct spi_device *spi)
>  	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
>  	lis3lv02d_joystick_disable();
>  	lis3lv02d_poweroff(lis3);
> -	return 0;
> +
> +	return lis3lv02d_remove_fs(&lis3_dev);
>  }
>  
>  #ifdef CONFIG_PM

