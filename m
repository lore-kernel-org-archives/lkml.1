Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYJWOLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYJWOLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYJWOLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:11:22 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59261 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751638AbYJWOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:11:22 -0400
Date: Thu, 23 Oct 2008 15:11:08 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC S3C: Add device_init_wakeup() invokation
Message-ID: <20081023141108.GA6099@fluff.org.uk>
References: <1224758815-23131-1-git-send-email-jekhor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224758815-23131-1-git-send-email-jekhor@gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 01:46:55PM +0300, Yauhen Kharuzhy wrote:
> This patch adds device_init_wakeup() ivokation to probe function of
                                       invocation
> s3c2410_rtc_driver. Without of this wakealarm sysfs attribute does not
> initialise.
> 
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>  drivers/rtc/rtc-s3c.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index 9a92ee1..70d9fc3 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -455,6 +455,8 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
>  
>  	s3c_rtc_setfreq(&pdev->dev, 1);
>  
> +	device_init_wakeup(&pdev->dev, 1);
> +
>  	/* register RTC and exit */
>  
>  	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
