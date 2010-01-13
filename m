Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788Ab0AMD6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0AMD6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 22:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777Ab0AMD6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 22:58:35 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:21371 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0AMD6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 22:58:35 -0500
Date: Tue, 12 Jan 2010 20:58:33 -0700
From: Alex Chiang <achiang@hp.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
Subject: Re: [patch 4/6] acpi: Fix section mismatch
Message-ID: <20100113035833.GA17378@ldl.fc.hp.com>
References: <20100113004855.550486769@suse.com> <20100113004939.103771236@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113004939.103771236@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck already sent a patch for this to Len Brown (which I
acked).

Thanks,
/ac

* Jeff Mahoney <jeffm@suse.com>:
>  acpi_early_processor_set_pdc uses processor_idle_dmi_table, which is
>  marked __cpuinitdata. It's only called by acpi_bus_init, which is __init.
>  We mark it __cpuinit.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  drivers/acpi/processor_pdc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/acpi/processor_pdc.c
> +++ b/drivers/acpi/processor_pdc.c
> @@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 l
>  	return AE_OK;
>  }
>  
> -void acpi_early_processor_set_pdc(void)
> +void __cpuinit acpi_early_processor_set_pdc(void)
>  {
>  	/*
>  	 * Check whether the system is DMI table. If yes, OSPM
> 
> 
