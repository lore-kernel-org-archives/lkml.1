Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXHETt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXHETt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbXHETtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:49:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:41444 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbXHETtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:49:46 -0400
Subject: Re: [PATCH] sonypi: Fix initialization warning
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Ben Collins <bcollins@ubuntu.com>, "Brown, Len" <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Stelian Pop <stelian@popies.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B61F70.90005@student.ltu.se>
References: <46B61F70.90005@student.ltu.se>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 21:50:43 +0200
Message-Id: <1186343443.3858.46.camel@fanta4.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 21:05 +0200, Richard Knutsson wrote:
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Got this from the compiler (gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-13)):
> drivers/char/sonypi.c:1153: warning: initialization from incompatible pointer type
> 
> 
> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> index 73037a4..2dcd519 100644
> --- a/drivers/char/sonypi.c
> +++ b/drivers/char/sonypi.c
> @@ -1147,10 +1147,15 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
>  	return 0;
>  }
>  
> +static const struct acpi_device_id sonypi_acpi_driver_ids[] = {
> +        {ACPI_PROCESSOR_HID, 0},
This is wrong. You need to take the HID the driver should match for, in
this case: {"SNY6001", 0 },

> +        {"", 0},
> +};
> +
>  static struct acpi_driver sonypi_acpi_driver = {
>  	.name           = "sonypi",
>  	.class          = "hkey",
> -	.ids            = "SNY6001",
> +	.ids            = sonypi_acpi_driver_ids,
>  	.ops            = {
>  		           .add = sonypi_acpi_add,
>  			   .remove = sonypi_acpi_remove,

A patch from Eugene Teo fixing this is already on the list of Len's
patches.
See subject: [PATCH 04/12] sonypi: fix ids member of struct acpi_driver
posted yesterday on linux-acpi.
Anyway, thanks for the heads up,

    Thomas

