Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZC1JcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZC1JcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZC1JcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:32:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:18216 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZC1JcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TBeqB8M45xM1uPDMX2BEiUIzMgHE+9IOfhBdT62w9yMayqc+QjQGdmZ65nzdrUVBsw
         7+phTb/mh+u5EL5Q5WF4AX5vmVSh6rZXjex64nJ62rWFO8EO+/U12ZQ5EW1gbo1UMVpP
         5dd3ALv+sGOOik78/g0MF4HU3oKDpCvtZZtgQ=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-47-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-47-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 17:32:02 +0800
Message-ID: <f17812d70903280232i12f4ce68h1acff0667212286c@mail.gmail.com>
Subject: Re: [PATCH 47/58] move sharpsl-pm's probe function to .devinit.text
From: Eric Miao <eric.y.miao@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to sharpsl_pm_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>

This one looks OK to me.

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/arm/common/sharpsl_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/common/sharpsl_pm.c b/arch/arm/common/sharpsl_pm.c
> index 780bbf7..e88c9ca 100644
> --- a/arch/arm/common/sharpsl_pm.c
> +++ b/arch/arm/common/sharpsl_pm.c
> @@ -780,7 +780,7 @@ static struct platform_suspend_ops sharpsl_pm_ops = {
>  };
>  #endif
>
> -static int __init sharpsl_pm_probe(struct platform_device *pdev)
> +static int __devinit sharpsl_pm_probe(struct platform_device *pdev)
>  {
>        int ret;
>
> --
> 1.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
