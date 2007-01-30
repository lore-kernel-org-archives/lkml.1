Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXA3HSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXA3HSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965223AbXA3HSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:18:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:45094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXA3HS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:18:29 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT".
Date: Tue, 30 Jan 2007 02:17:09 -0500
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0701270145540.32670@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701270145540.32670@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701300217.09406.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heh, you're right Robert -- this was a typo.
So I applied your patch, looked at my dmesg and realized that
we don't need the output it enables, so I deleted the whole routine:-)

thanks,
-Len

On Saturday 27 January 2007 01:55, Robert P. J. Day wrote:
> 
>   Replace the apparent typo CONFIG_ACPI_DEBUG_OUTPUT with
> the non-Kconfig conditional ACPI_DEBUG_OUTPUT, which is what every
> other file uses.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 698a154..d65142a 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -891,7 +891,7 @@ static int acpi_device_set_context(struct acpi_device *device, int type)
>  static void acpi_device_get_debug_info(struct acpi_device *device,
>  				       acpi_handle handle, int type)
>  {
> -#ifdef CONFIG_ACPI_DEBUG_OUTPUT
> +#ifdef ACPI_DEBUG_OUTPUT
>  	char *type_string = NULL;
>  	char name[80] = { '?', '\0' };
>  	struct acpi_buffer buffer = { sizeof(name), name };
> @@ -928,7 +928,7 @@ static void acpi_device_get_debug_info(struct acpi_device *device,
>  	}
> 
>  	printk(KERN_DEBUG "Found %s %s [%p]\n", type_string, name, handle);
> -#endif				/*CONFIG_ACPI_DEBUG_OUTPUT */
> +#endif				/* ACPI_DEBUG_OUTPUT */
>  }
> 
>  static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
> 
