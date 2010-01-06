Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505Ab0AFWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0AFWwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491Ab0AFWwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:52:15 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13052 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab0AFWwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:52:14 -0500
Date: Wed, 6 Jan 2010 15:52:12 -0700
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section mismatch error for
	acpi_early_processor_set_pdc()
Message-ID: <20100106225212.GF19218@ldl.fc.hp.com>
References: <20091220191909.4274.63584.stgit@bob.kio> <4b38fb5b18912746ff@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b38fb5b18912746ff@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony <tony.luck@intel.com>:
> Alex Chiang introduced acpi_early_processor_set_pdc() in commit:
>  ACPI: processor: call _PDC early
>  78f1699659963fff97975df44db6d5dbe7218e55
> 
> But this results in a section mismatch:
> 
> WARNING: drivers/acpi/acpi.o(.text+0xa9c1): Section mismatch in reference from the
> function acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table
> The function acpi_early_processor_set_pdc() references
> the variable __cpuinitdata processor_idle_dmi_table.
> This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata
> annotation or the annotation of processor_idle_dmi_table is wrong.
> 
> The only caller of acpi_early_processor_set_pdc() is acpi_bus_init() which
> is an "__init" function. So the correct fix here is to mark
> acpi_early_processor_set_pdc() "__init" too.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Alex Chiang <achiang@hp.com>

Sorry for not catching this. Not sure why I didn't notice it
myself.

/ac

> 
> ---
> 
> diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
> index 30e4dc0..7d4ee39 100644
> --- a/drivers/acpi/processor_pdc.c
> +++ b/drivers/acpi/processor_pdc.c
> @@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK;
>  }
>  
> -void acpi_early_processor_set_pdc(void)
> +void __init acpi_early_processor_set_pdc(void)
>  {
>  	/*
>  	 * Check whether the system is DMI table. If yes, OSPM
> 
