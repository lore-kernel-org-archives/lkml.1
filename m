Return-Path: <linux-kernel-owner+w=401wt.eu-S934537AbXLMXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbXLMXDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763293AbXLMXDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:03:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762826AbXLMXDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:03:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] acpi: make __acpi_map_table() and __init function
Date: Thu, 13 Dec 2007 18:03:07 -0500
User-Agent: KMail/1.9.5
Cc: "linux-acpi" <linux-acpi@intel.com>, linux-kernel@vger.kernel.org
References: <4760FC87.76E4.0078.0@novell.com>
In-Reply-To: <4760FC87.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131803.07985.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to 2.6.25 queue

thanks,
-Len

On Thursday 13 December 2007 03:33, Jan Beulich wrote:
> .. as it it used only during early boot.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
>  arch/ia64/kernel/acpi.c     |    2 +-
>  arch/x86/kernel/acpi/boot.c |    4 ++--
>  drivers/acpi/osl.c          |    3 ++-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.24-rc5/arch/ia64/kernel/acpi.c	2007-12-12 11:28:03.000000000 +0100
> +++ 2.6.24-rc5-acpi-map-table-init/arch/ia64/kernel/acpi.c	2007-12-04 16:09:33.000000000 +0100
> @@ -152,7 +152,7 @@ int acpi_request_vector(u32 int_type)
>  	return vector;
>  }
>  
> -char *__acpi_map_table(unsigned long phys_addr, unsigned long size)
> +char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
>  {
>  	return __va(phys_addr);
>  }
> --- linux-2.6.24-rc5/arch/x86/kernel/acpi/boot.c	2007-12-12 11:28:17.000000000 +0100
> +++ 2.6.24-rc5-acpi-map-table-init/arch/x86/kernel/acpi/boot.c	2007-12-04 16:09:33.000000000 +0100
> @@ -106,7 +106,7 @@ enum acpi_irq_model_id acpi_irq_model = 
>  #ifdef	CONFIG_X86_64
>  
>  /* rely on all ACPI tables being in the direct mapping */
> -char *__acpi_map_table(unsigned long phys_addr, unsigned long size)
> +char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
>  {
>  	if (!phys_addr || !size)
>  		return NULL;
> @@ -131,7 +131,7 @@ char *__acpi_map_table(unsigned long phy
>   * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
>   * count idx down while incrementing the phys address.
>   */
> -char *__acpi_map_table(unsigned long phys, unsigned long size)
> +char *__init __acpi_map_table(unsigned long phys, unsigned long size)
>  {
>  	unsigned long base, offset, mapped_size;
>  	int idx;
> --- linux-2.6.24-rc5/drivers/acpi/osl.c	2007-12-12 11:28:21.000000000 +0100
> +++ 2.6.24-rc5-acpi-map-table-init/drivers/acpi/osl.c	2007-12-04 16:09:33.000000000 +0100
> @@ -211,7 +211,8 @@ acpi_physical_address __init acpi_os_get
>  		return acpi_find_rsdp();
>  }
>  
> -void __iomem *acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
> +void __iomem *__init_refok
> +acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>  {
>  	if (phys > ULONG_MAX) {
>  		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
