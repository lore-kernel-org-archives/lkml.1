Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXFMWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXFMWUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXFMWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:20:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:30265 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbXFMWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QsGolP4FP6412PFcIbBakE+J6U0NcM/50SVSLlWRqAHBj0n8NrrCcWdhNLwpvlVYZtJG9kcJDp63y28voutzCkkkc/D1YBCvy7AEkmhsZeQDEsR+FBNNQecXNQ0SQC3XFmhpXC9nHCUyJK6zHR+qgJAha746zijj/2L6WpsQWLw=
Message-ID: <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com>
Date: Thu, 14 Jun 2007 00:20:11 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200706131620.54338.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706131551.51336.rjw@sisk.pl> <200706131620.54338.rjw@sisk.pl>
X-Google-Sender-Auth: 10edbb256fe8085a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry, you added this recently, is this used in any code you plan to
merge soon?

Thanks,
Kay

On 6/13/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The suspend and resume support in struct device_type (include/linux/device.h)
> is not used anywhere.  It is also undocumented, so it can be removed.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/resume.c  |    5 -----
>  drivers/base/power/suspend.c |    7 -------
>  include/linux/device.h       |    2 --
>  3 files changed, 14 deletions(-)
>
> Index: linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/drivers/base/power/resume.c
> +++ linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
> @@ -41,11 +41,6 @@ int resume_device(struct device * dev)
>                 error = dev->bus->resume(dev);
>         }
>
> -       if (!error && dev->type && dev->type->resume) {
> -               dev_dbg(dev,"resuming\n");
> -               error = dev->type->resume(dev);
> -       }
> -
>         if (!error && dev->class && dev->class->resume) {
>                 dev_dbg(dev,"class resume\n");
>                 error = dev->class->resume(dev);
> Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
> +++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
> @@ -79,13 +79,6 @@ int suspend_device(struct device * dev,
>                 suspend_report_result(dev->class->suspend, error);
>         }
>
> -       if (!error && dev->type && dev->type->suspend
> -           && !dev->power.power_state.event) {
> -               suspend_device_dbg(dev, state, "type ");
> -               error = dev->type->suspend(dev, state);
> -               suspend_report_result(dev->type->suspend, error);
> -       }
> -
>         if (!error && dev->bus && dev->bus->suspend
>             && !dev->power.power_state.event) {
>                 suspend_device_dbg(dev, state, "");
> Index: linux-2.6.22-rc4-mm2/include/linux/device.h
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/include/linux/device.h
> +++ linux-2.6.22-rc4-mm2/include/linux/device.h
> @@ -340,8 +340,6 @@ struct device_type {
>         int (*uevent)(struct device *dev, char **envp, int num_envp,
>                       char *buffer, int buffer_size);
>         void (*release)(struct device *dev);
> -       int (*suspend)(struct device * dev, pm_message_t state);
> -       int (*resume)(struct device * dev);
>  };
>
>  /* interface for exporting device attributes */
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
