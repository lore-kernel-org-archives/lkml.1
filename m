Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab0APHHJ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 02:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210Ab0APHHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 02:07:07 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:56052 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0APHHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 02:07:06 -0500
Date: Sat, 16 Jan 2010 02:07:00 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustycorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Ashok Raj <ashok.raj@intel.com>, tony.luck@intel.com,
        Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] Section mismatch: acpi_early_processor_set_pdc()
In-reply-to: <201001132244.49209.mitov@issp.bas.bg>
Message-id: <alpine.LFD.2.00.1001160206070.10250@localhost.localdomain>
References: <201001132244.49209.mitov@issp.bas.bg>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think tony's patch (in my tree) to change this to __init is correct.

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 13 Jan 2010, Marin Mitov wrote:

> Hi all,
> 
> kernel-2.6.33-rc4, compiler output:
> 
> WARNING: Section mismatch in reference from the function 
> acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table                                                                                           
> The function acpi_early_processor_set_pdc() references                                                                            
> the variable __cpuinitdata processor_idle_dmi_table.                                                                              
> This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata                                                          
> annotation or the annotation of processor_idle_dmi_table is wrong.   
> 
> acpi_early_processor_set_pdc() is invoked only from __init acpi_bus_init()  
> Mark it __cpuinit.
> 
> The patch is against 2.6.33-rc4
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> 
> ===========================================================================
> --- a/drivers/acpi/processor_pdc.c	2010-01-13 21:53:14.000000000 +0200
> +++ b/drivers/acpi/processor_pdc.c	2010-01-13 21:58:39.000000000 +0200
> @@ -151,7 +151,7 @@
>  	return AE_OK;
>  }
>  
> -void acpi_early_processor_set_pdc(void)
> +void __cpuinit acpi_early_processor_set_pdc(void)
>  {
>  	/*
>  	 * Check whether the system is DMI table. If yes, OSPM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
