Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXJaCdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXJaCdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXJaCdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:33:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXJaCdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:33:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] acpi: 'acpi_gbl_system_awake_and_running' is no longer used, only assigned.
Date: Tue, 30 Oct 2007 22:33:20 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071030104750.30935.5409.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071030104750.30935.5409.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302233.20440.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob reports that this is used in a pending version of ACPICA,
so we'll leave the code alone.

thanks,
-Len

On Tuesday 30 October 2007 06:54, Richard Knutsson wrote:
> 'acpi_gbl_system_awake_and_running' is no longer used, only assigned.
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Diffed against linus-git
> Checked with script/checkpatch.pl
> 
>  drivers/acpi/hardware/hwsleep.c   |    5 -----
>  drivers/acpi/utilities/utglobal.c |    1 -
>  include/acpi/acglobal.h           |    1 -
>  3 files changed, 7 deletions(-)
> 
> 
> diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
> index 81b2484..e020e50 100644
> --- a/drivers/acpi/hardware/hwsleep.c
> +++ b/drivers/acpi/hardware/hwsleep.c
> @@ -300,8 +300,6 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
>  		return_ACPI_STATUS(status);
>  	}
>  
> -	acpi_gbl_system_awake_and_running = FALSE;
> -
>  	status = acpi_hw_enable_all_wakeup_gpes();
>  	if (ACPI_FAILURE(status)) {
>  		return_ACPI_STATUS(status);
> @@ -446,7 +444,6 @@ acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void)
>  	if (ACPI_FAILURE(status)) {
>  		return_ACPI_STATUS(status);
>  	}
> -	acpi_gbl_system_awake_and_running = FALSE;
>  
>  	status = acpi_hw_enable_all_wakeup_gpes();
>  	if (ACPI_FAILURE(status)) {
> @@ -587,8 +584,6 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
>  	}
>  	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
>  
> -	acpi_gbl_system_awake_and_running = TRUE;
> -
>  	/* Enable power button */
>  
>  	(void)
> diff --git a/drivers/acpi/utilities/utglobal.c b/drivers/acpi/utilities/utglobal.c
> index 93ea829..f2ba315 100644
> --- a/drivers/acpi/utilities/utglobal.c
> +++ b/drivers/acpi/utilities/utglobal.c
> @@ -709,7 +709,6 @@ void acpi_ut_init_globals(void)
>  	/* Hardware oriented */
>  
>  	acpi_gbl_events_initialized = FALSE;
> -	acpi_gbl_system_awake_and_running = TRUE;
>  
>  	/* Namespace */
>  
> diff --git a/include/acpi/acglobal.h b/include/acpi/acglobal.h
> index 347a911..ae0fc0a 100644
> --- a/include/acpi/acglobal.h
> +++ b/include/acpi/acglobal.h
> @@ -236,7 +236,6 @@ ACPI_EXTERN u8 acpi_gbl_step_to_next_call;
>  ACPI_EXTERN u8 acpi_gbl_acpi_hardware_present;
>  ACPI_EXTERN u8 acpi_gbl_global_lock_present;
>  ACPI_EXTERN u8 acpi_gbl_events_initialized;
> -ACPI_EXTERN u8 acpi_gbl_system_awake_and_running;
>  
>  extern u8 acpi_gbl_shutdown;
>  extern u32 acpi_gbl_startup_flags;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
