Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbYAKVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbYAKVBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759109AbYAKVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:01:33 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54115 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbYAKVBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:01:33 -0500
Date: Fri, 11 Jan 2008 23:00:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/4] introduce __cpuinitconst
Message-ID: <20080111210044.GA17276@does.not.exist>
References: <47873D40.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47873D40.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 08:56:16AM +0000, Jan Beulich wrote:
> The patch doesn't change all instances where 'const' could have been
> added as a result of the base structure changes, only where the change
> has a real effect (the module loader doesn't enforce read-only section
> attributes at present, so only built-in files make a real difference).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Andi Kleen <ak@suse.de>
> 
> ---
>  drivers/acpi/processor_idle.c |    2 +-
>  include/linux/init.h          |    2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- 2.6.24-rc7-initconst.orig/drivers/acpi/processor_idle.c
> +++ 2.6.24-rc7-initconst/drivers/acpi/processor_idle.c
> @@ -118,7 +118,7 @@ static int set_max_cstate(const struct d
>  
>  /* Actually this shouldn't be __cpuinitdata, would be better to fix the
>     callers to only run once -AK */
> -static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
> +static struct dmi_system_id __cpuinitconst processor_power_dmi_table[] = {
>  	{ set_max_cstate, "IBM ThinkPad R40e", {
>  	  DMI_MATCH(DMI_BIOS_VENDOR,"IBM"),
>  	  DMI_MATCH(DMI_BIOS_VERSION,"1SET70WW")}, (void *)1},
> --- 2.6.24-rc7-initconst.orig/include/linux/init.h
> +++ 2.6.24-rc7-initconst/include/linux/init.h
> @@ -269,11 +269,13 @@ void __init parse_early_param(void);
>  #ifdef CONFIG_HOTPLUG_CPU
>  #define __cpuinit
>  #define __cpuinitdata
> +#define __cpuinitconst const
>  #define __cpuexit
>  #define __cpuexitdata
>  #else
>  #define __cpuinit	__init
>  #define __cpuinitdata __initdata
> +#define __cpuinitconst __initdata
>  #define __cpuexit __exit
>  #define __cpuexitdata	__exitdata
>  #endif

__cpuinitconstdata ?

I know it's a bit long, but it would be more logically when looking at 
the other ones.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

