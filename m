Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXCAHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXCAHgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXCAHgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:36:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:60498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096AbXCAHgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:36:11 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: John Keller <jpk@sgi.com>
Subject: Re: [PATCH 1/1] - Altix: reinitialize acpi tables
Date: Thu, 1 Mar 2007 02:36:41 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, ayoung@sgi.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070228234727.11369.38394.sendpatchset@attica.americas.sgi.com>
In-Reply-To: <20070228234727.11369.38394.sendpatchset@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703010236.42128.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so will the 1st acpi_table_init() always fail -- even
on future machines?

-Len

On Wednesday 28 February 2007 18:47, John Keller wrote:
> To provide compatibilty with SN kernels that do and do not
> have ACPI IO support, the SN PROM must build different
> versions of some ACPI tables based on which kernel is booting.
> As such, the tables may have to change at kernel boot time.
> By default, prior to kernel boot, the PROM builds an empty
> DSDT (header only) and no SSDTs. If an ACPI capable kernel
> boots, the kernel will notify the PROM, at platform setup time,
> and the PROM will build full DSDT and SSDT tables.
> 
> With the latest changes to acpi_table_init(), the table lengths
> are saved, and when our PROM changes them, the changes are not seen,
> and the kernel will crash on boot. Because of issues with kexec support,
> we are not able to create the tables prior to acpi_table_init().
> As a result, we are making a second call to acpi_table_init() to
> process the rebuilt DSDT and SSDTs.
> 
> Signed-off-by: John Keller <jpk@sgi.com>
> ---
> 
> 
> Index: release/arch/ia64/sn/kernel/setup.c
> ===================================================================
> --- release.orig/arch/ia64/sn/kernel/setup.c	2007-02-28 11:02:34.558139870 -0600
> +++ release/arch/ia64/sn/kernel/setup.c	2007-02-28 11:02:39.362737953 -0600
> @@ -397,6 +397,8 @@ void __init sn_setup(char **cmdline_p)
>  	ia64_sn_set_os_feature(OSF_PCISEGMENT_ENABLE);
>  	ia64_sn_set_os_feature(OSF_ACPI_ENABLE);
>  
> +	/* Load the new DSDT and SSDT tables into the global table list. */
> + 	acpi_table_init();
>  
>  #if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
>  	/*
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
