Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbZHVLUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbZHVLUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933260AbZHVLUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:20:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63973 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbZHVLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YQfI39YKIIdmwmUrlN+4wKX33hIgmukF8F+39tsXeUi/awZQ2OUGDlGid4tcGWNFO+
         dtjihTac4b5jt97lHKFZfUmxZP2xFdqS6bMw8EF4mSoKiiEyqlcTz0eYwHUKU3FPQ3qj
         0yysOSzbqZuN/yrqpDLqF7vrBjqHt+arKQd5Q=
MIME-Version: 1.0
In-Reply-To: <1250890778-28959-1-git-send-email-Mario_Limonciello@Dell.com>
References: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
	 <1250890778-28959-1-git-send-email-Mario_Limonciello@Dell.com>
Date: Sat, 22 Aug 2009 12:20:27 +0100
Message-ID: <9b2b86520908220420p282c862fn9c44697db010a08d@mail.gmail.com>
Subject: Re: [PATCH] compal-laptop: Replace sysfs support with rfkill support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <Mario_Limonciello@dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-wireless@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/09, Mario Limonciello <Mario_Limonciello@dell.com> wrote:
> This drops the support for manually groking the files in sysfs
> to turn on and off the WLAN and BT for Compal laptops in favor
> of platform rfkill support.
>
> It has been combined into a single patch to not introduce regressions
> in the process of simply adding rfkill support.
>
> Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>

> @@ -390,23 +314,19 @@ static int __init compal_init(void)
>
>  	ret = platform_device_add(compal_device);
>  	if (ret)
> -		goto fail_platform_device1;
> +		goto fail_platform_device;
>
> -	ret = sysfs_create_group(&compal_device->dev.kobj,
> -		&compal_attribute_group);
> +	ret = setup_rfkill();
>  	if (ret)
> -		goto fail_platform_device2;
> +		goto fail_rfkill;
>
>  	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
>  		" successfully loaded.\n");
>
>  	return 0;
>
> -fail_platform_device2:
> -
> -	platform_device_del(compal_device);
> -
> -fail_platform_device1:
> +fail_rfkill:
> +fail_platform_device:
>
>  	platform_device_put(compal_device);
>

I guess our mails crossed.  As in the previous patch I think
platform_device_del() should still be called, in the fail_rfkill case.

Previously platform_device_del() was required after
platform_device_add(), if we bailed out because of a failure in
sysfs_create_group().  I don't think that requirement is removed by
replacing sysfs_create_group() with setup_rfkill().

Regards
Alan
