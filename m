Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXKNKzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXKNKzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXKNKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:55:05 -0500
Received: from www.tglx.de ([62.245.132.106]:33866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXKNKzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:55:03 -0500
Date: Wed, 14 Nov 2007 11:54:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] - [12/15] - remove defconfig ptr comparisons to 0 -
 include/asm-x86
In-Reply-To: <1195005932.5163.98.camel@localhost>
Message-ID: <alpine.LFD.0.9999.0711141055050.3265@localhost.localdomain>
References: <1195005932.5163.98.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

can you please CC the relevant maintainers on patches ?

On Tue, 13 Nov 2007, Joe Perches wrote:

> Remove defconfig ptr comparison to 0
>
> The memcpy from memory location 0 sure looks odd.

The memcpy from 0 is completely bogus.

I bet this should have been a memset(&header, 0, ....), which is not
necessary at all, when the return value of acpi_get_table_header()
would be evaluated.

/me wonders why this never exploded

    tglx

> Remove sparse warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
> diff --git a/include/asm-x86/mach-es7000/mach_mpparse.h b/include/asm-x86/mach-es7000/mach_mpparse.h
> index 8aa1054..a1dd66f 100644
> --- a/include/asm-x86/mach-es7000/mach_mpparse.h
> +++ b/include/asm-x86/mach-es7000/mach_mpparse.h
> @@ -29,7 +29,7 @@ extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
>  static inline int es7000_check_dsdt(void)
>  {
>  	struct acpi_table_header header;
> -	memcpy(&header, 0, sizeof(struct acpi_table_header));
> +	memcpy(&header, (void *)0, sizeof(struct acpi_table_header));
>  	acpi_get_table_header(ACPI_SIG_DSDT, 0, &header);
>  	if (!strncmp(header.oem_id, "UNISYS", 6))
>  		return 1;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
