Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683Ab0AZQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0AZQVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660Ab0AZQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab0AZQVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:21:03 -0500
Message-ID: <4B5F164B.5070602@redhat.com>
Date: Tue, 26 Jan 2010 11:20:27 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0b2pre Thunderbird/3.0b4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 07/29] move efifb's probe function to .devinit.text
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <1264278937-19675-7-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1264278937-19675-7-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2010 03:35 PM, Uwe Kleine-König wrote:
> A pointer to efifb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

__devinit looks reasonable enough to me.

Acked-By: Peter Jones <pjones@redhat.com>

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Maciej W. Rozycki <macro@linux-mips.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chandramouli Narayanan <mouli@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/video/efifb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index eb12182..2161f21 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -201,7 +201,7 @@ static int __init efifb_setup(char *options)
>  	return 0;
>  }
>  
> -static int __init efifb_probe(struct platform_device *dev)
> +static int __devinit efifb_probe(struct platform_device *dev)
>  {
>  	struct fb_info *info;
>  	int err;


-- 
        Peter

The trouble with the global village are all the global village idiots.
		-- Paul Ginsparg
