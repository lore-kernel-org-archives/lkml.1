Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbXF2QYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbXF2QYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765749AbXF2QYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:24:03 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62102 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761616AbXF2QYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:24:00 -0400
Date: Fri, 29 Jun 2007 12:23:43 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Zan Lynx <zlynx@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Message-ID: <20070629162343.GD27698@rhun.ibm.com>
References: <46845943.7050005@shaw.ca> <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com> <20070629152858.GA27995@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629152858.GA27995@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 08:28:58AM -0700, Keshavamurthy, Anil S wrote:

> Here is the revised patch of the above.
> Andrew, please add this fix to
> +intel-iommu-dmar-detection-and-parsing-logic.patch
> ------------------------------------------------
> 
> Check for dmar_tbl pointer as this can be NULL on 
> systems with no Intel VT-d support.
> 
> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> 
> ---
>  drivers/pci/dmar.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.22-rc4-mm2/drivers/pci/dmar.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/drivers/pci/dmar.c	2007-06-29 07:43:43.000000000 -0700
> +++ linux-2.6.22-rc4-mm2/drivers/pci/dmar.c	2007-06-29 07:46:25.000000000 -0700
> @@ -260,6 +260,8 @@
>  	int ret = 0;
>  
>  	dmar = (struct acpi_table_dmar *)dmar_tbl;
> +	if (!dmar)
> +		return -ENODEV;
>  
>  	if (!dmar->width) {
>  		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
> @@ -301,7 +303,7 @@
>  
>  	parse_dmar_table();
>  	if (list_empty(&dmar_drhd_units)) {
> -		printk(KERN_ERR PREFIX "No DMAR devices found\n");
> +		printk(KERN_INFO PREFIX "No DMAR devices found\n");
>  		return -ENODEV;
>  	}
>  	return 0;

The convention is to print a KERN_DEBUG message if hardware is not
found when probing it, otherwise the boot messages become cluttered
with lots of "$FOO not found".

Cheers,
Muli
