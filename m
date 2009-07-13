Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbZGMNwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbZGMNwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZGMNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:52:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZGMNwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:52:21 -0400
Message-ID: <4A5B3BEF.1020207@redhat.com>
Date: Mon, 13 Jul 2009 09:51:43 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
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
Subject: Re: [PATCH] move efifb's probe function to .devinit.text
References: <20090711170548.GC5205@suse.de> <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 04:52 PM, Uwe Kleine-König wrote:
> A pointer to efifb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.

Looks good to me:

Acked-by: Peter Jones <pjones@redhat.com>

> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
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

In computer science, about the only thing we can prove is that traveling
salesmen can't find their way from one place to another effeciently, and
that unix hackers can't really decode 40-bit keys by harnessing all the
computers in the lab.  And the hackers do it anyway, and the salesmen still
make their rounds.
		-- Ron Jeffries, WikiWikiWeb
