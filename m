Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZDQAGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZDQAGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZDQAGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:06:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:63467 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZDQAGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=macM5wAOIeD3t/kEb+FaqP/RENxPwqyiwBmKB1cnTZ2SEEuxfzDXpapkAs6WO2k7En
         PqjoOtdn2dK0SK3rOSSxkCAa/dirEzzNqfy36WOCrHkJe1Uyfiq2Jt8HUh+4dIQoqfL5
         eBe+KCwZvPOuUJeNWhAH8iXij78P24fcBNRUg=
MIME-Version: 1.0
In-Reply-To: <1239889828-7300-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239889828-7300-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Fri, 17 Apr 2009 08:06:23 +0800
Message-ID: <d82e647a0904161706o1285219dja9c89d71190d173@mail.gmail.com>
Subject: Re: [PATCH] platform: Do not complain for platform_data added by 
	platform_device_add_data()
From: Ming Lei <tom.leiming@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/16 Atsushi Nemoto <anemo@mba.ocn.ne.jp>:
> The commit ce21c7bc ("driver core: fix passing platform_data") added
> an error message "foo: use which platform_data?", but this is normal
> if platform_device_add_data() was used.
>
> Do not print the error message if pdev->platform_data and
> pdev->dev.platform_data have same value.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Ming Lei <tom.leiming@gmail.com>

> ---
>  drivers/base/platform.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index d2198f6..f984376 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -253,7 +253,8 @@ int platform_device_add(struct platform_device *pdev)
>        * long time, so we allow the two cases coexist to make
>        * this kind of fix more easily*/
>        if (pdev->platform_data && pdev->dev.platform_data) {
> -               printk(KERN_ERR
> +               if (pdev->platform_data != pdev->dev.platform_data)
> +                       printk(KERN_ERR
>                               "%s: use which platform_data?\n",
>                               dev_name(&pdev->dev));
>        } else if (pdev->platform_data) {
> --
> 1.5.6.3
>
>



-- 
Lei Ming
