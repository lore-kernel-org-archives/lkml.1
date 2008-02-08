Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYBHF1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYBHF1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYBHF1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:27:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:46986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYBHF1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:27:12 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Fri, 8 Feb 2008 00:26:40 -0500
User-Agent: KMail/1.9.5
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <2c0942db0802071612r1b32f996jc26ac3792b8c31fc@mail.gmail.com> <200802080119.08872.carlos@strangeworlds.co.uk>
In-Reply-To: <200802080119.08872.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080026.41139.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

good description, Carlos.

applied.
thanks,
-Len

On Thursday 07 February 2008 20:19, Carlos Corbacho wrote:
> On Friday 08 February 2008 00:12:24 Ray Lee wrote:
> > On Feb 7, 2008 3:51 PM, Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:
> > > On Thursday 07 February 2008 23:33:54 Ray Lee wrote:
> > > > Do you have list of hardware/platforms that require this feature to
> > > > get the hardware to work? (acer abc123, tcm1100 xyz)
> > >
> > > I have a very long list of Acer laptops that are supported - which is far
> > > too long, and changes on far too much of a regular basis to put in there.
> > >
> > > Perhaps adding something like "This driver is also a required dependency
> > > to build the firmware specific drivers needed for many laptops, including
> > > Acer and HP machines"?
> 
> Would this be acceptable then?
> 
> -Carlos
> ---
> ACPI: WMI: Improve Kconfig entry
> 
> From: Carlos Corbacho <carlos@strangeworlds.co.uk>
> 
> As Pavel Machek has pointed out, the Kconfig entry for WMI is pretty
> non-descriptive.
> 
> Rewrite it so that it explains what ACPI-WMI is, and why anyone
> would want to enable it.
> 
> Many thanks to Ray Lee for ideas on this.
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> CC: Pavel Machek <pavel@ucw.cz>
> CC: Ray Lee <ray-lk@madrabbit.org>
> CC: Len Brown <lenb@kernel.org>
> ---
> 
>  drivers/acpi/Kconfig |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index b7fbf16..ea763ef 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -207,11 +207,22 @@ config ACPI_WMI
>  	depends on EXPERIMENTAL
>  	depends on X86
>  	help
> -	  This driver adds support for the ACPI-WMI mapper device (PNP0C14)
> -	  found on some systems.
> +	  This driver adds support for the ACPI-WMI (Windows Management
> +	  Instrumentation) mapper device (PNP0C14) found on some systems.
>  
> -	  NOTE: You will need another driver or userspace application on top of
> -	  this to actually use anything defined in the ACPI-WMI mapper.
> +	  ACPI-WMI is a proprietary extension to ACPI to expose parts of the
> +	  ACPI firmware to userspace - this is done through various vendor
> +	  defined methods and data blocks in a PNP0C14 device, which are then
> +	  made available for userspace to call.
> +
> +	  The implementation of this in Linux currently only exposes this to
> +	  other kernel space drivers.
> +
> +	  This driver is a required dependency to build the firmware specific
> +	  drivers needed on many machines, including Acer and HP laptops.
> +
> +	  It is safe to enable this driver even if your DSDT doesn't define
> +	  any ACPI-WMI devices.
>  
>  config ACPI_ASUS
>          tristate "ASUS/Medion Laptop Extras"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
