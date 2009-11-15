Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZKOPtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZKOPtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZKOPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:49:32 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:2871 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZKOPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:49:32 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B00230D.3090808@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:49:33 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 02/10] LIS3LV02D: Correct memory leak in module unload
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> polled input device itself was not free'd.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
> ---
>  drivers/hwmon/lis3lv02d.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 7f43a3b..dbd0b05 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -333,6 +333,7 @@ void lis3lv02d_joystick_disable(void)
>  	if (lis3_dev.irq)
>  		misc_deregister(&lis3lv02d_misc_device);
>  	input_unregister_polled_device(lis3_dev.idev);
> +	input_free_polled_device(lis3_dev.idev);
>  	lis3_dev.idev = NULL;
>  }
>  EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);

