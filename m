Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbZJIPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbZJIPZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933451AbZJIPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:25:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:46447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207AbZJIPZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:25:31 -0400
Date: Fri, 9 Oct 2009 17:24:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] move stk17ta8's probe function to .devinit.text
In-Reply-To: <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LSU.2.00.0910091724170.19284@wotan.suse.de>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1815770326-1255101893=:19284"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1815770326-1255101893=:19284
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 11 Jul 2009, Uwe Kleine-König wrote:

> A pointer to stk17ta8_rtc_probe is passed to the core via
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
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hannes Eder <hannes@hanneseder.net>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/rtc/rtc-stk17ta8.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
> index 7d1547b..d491eb2 100644
> --- a/drivers/rtc/rtc-stk17ta8.c
> +++ b/drivers/rtc/rtc-stk17ta8.c
> @@ -286,7 +286,7 @@ static struct bin_attribute stk17ta8_nvram_attr = {
>  	.write = stk17ta8_nvram_write,
>  };
>  
> -static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
> +static int __devinit stk17ta8_rtc_probe(struct platform_device *pdev)
>  {
>  	struct rtc_device *rtc;
>  	struct resource *res;

This seems to get lost ... should I take it through my tree, or is anyone 
going to merge it? Andrew? Alessandro?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-1815770326-1255101893=:19284--
