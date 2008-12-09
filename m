Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYLIRk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYLIRk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYLIRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:40:13 -0500
Received: from kroah.org ([198.145.64.141]:60434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753555AbYLIRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:40:11 -0500
Date: Tue, 9 Dec 2008 09:39:14 -0800
From: Greg KH <greg@kroah.com>
To: Len Brown <lenb@kernel.org>
Cc: stable@kernel.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2.6.23..2.6.27.stable] ACPI: delete OSI(Linux)
	DMI dmesg spam
Message-ID: <20081209173914.GC32344@kroah.com>
References: <alpine.LFD.2.00.0812081556060.4406@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812081556060.4406@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 04:03:07PM -0500, Len Brown wrote:
> Per 2.6.28 commit a6e0887f21bbab337ee32d9c0a84d7c0b6e9141b,
> stop soliciting DMI info for this BIOS issue.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

I don't understand, this isn't commit a6e0887f21bb upstream, right?

Is this patch upstream?  Or is it just that you don't want to get these
messages anymore because it is fixed in 2.6.28 now?

thanks,

greg k-h

> ---
> This patch applies cleanly to 2.6.26 and 2.6.27
> It applies with various offsets to 2.6.23, 2.6.24, 2.6.25
> 
> thanks,
> -Len Brown
> Intel Open Source Technology Center
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 235a138..b0d40aa 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1261,34 +1261,6 @@ acpi_status acpi_os_release_object(acpi_cache_t * cache, void *object)
>  	return (AE_OK);
>  }
>  
> -/**
> - *	acpi_dmi_dump - dump DMI slots needed for blacklist entry
> - *
> - *	Returns 0 on success
> - */
> -static int acpi_dmi_dump(void)
> -{
> -
> -	if (!dmi_available)
> -		return -1;
> -
> -	printk(KERN_NOTICE PREFIX "DMI System Vendor: %s\n",
> -		dmi_get_system_info(DMI_SYS_VENDOR));
> -	printk(KERN_NOTICE PREFIX "DMI Product Name: %s\n",
> -		dmi_get_system_info(DMI_PRODUCT_NAME));
> -	printk(KERN_NOTICE PREFIX "DMI Product Version: %s\n",
> -		dmi_get_system_info(DMI_PRODUCT_VERSION));
> -	printk(KERN_NOTICE PREFIX "DMI Board Name: %s\n",
> -		dmi_get_system_info(DMI_BOARD_NAME));
> -	printk(KERN_NOTICE PREFIX "DMI BIOS Vendor: %s\n",
> -		dmi_get_system_info(DMI_BIOS_VENDOR));
> -	printk(KERN_NOTICE PREFIX "DMI BIOS Date: %s\n",
> -		dmi_get_system_info(DMI_BIOS_DATE));
> -
> -	return 0;
> -}
> -
> -
>  /******************************************************************************
>   *
>   * FUNCTION:    acpi_os_validate_interface
> @@ -1315,14 +1287,6 @@ acpi_os_validate_interface (char *interface)
>  			osi_linux.cmdline ? " via cmdline" :
>  			osi_linux.dmi ? " via DMI" : "");
>  
> -		if (!osi_linux.dmi) {
> -			if (acpi_dmi_dump())
> -				printk(KERN_NOTICE PREFIX
> -					"[please extract dmidecode output]\n");
> -			printk(KERN_NOTICE PREFIX
> -				"Please send DMI info above to "
> -				"linux-acpi@vger.kernel.org\n");
> -		}
>  		if (!osi_linux.known && !osi_linux.cmdline) {
>  			printk(KERN_NOTICE PREFIX
>  				"If \"acpi_osi=%sLinux\" works better, "
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
