Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYFEUTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYFEUTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYFEUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:18:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYFEUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:18:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove include/linux/pm_legacy.h
Date: Thu, 5 Jun 2008 22:19:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       rmk@arm.linux.org.uk
References: <20080605182311.GC1469@cs181133002.pp.htv.fi>
In-Reply-To: <20080605182311.GC1469@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052219.11565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 of June 2008, Adrian Bunk wrote:
> This patch removes the obsolete and no longer used 
> include/linux/pm_legacy.h
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>


> ---
> 
> BTW: arch/arm/mach-sa1100/h3600.c:h3800_pm_callback() still tries to 
>      handle PM_{SUSPEND,RESUME}, but that's not touched by this patch.
> 
>  arch/frv/kernel/pm.c            |    1 
>  arch/mips/au1000/common/power.c |    1 
>  arch/x86/kernel/apm_32.c        |    1 
>  include/linux/pm_legacy.h       |   35 --------------------------------
>  4 files changed, 38 deletions(-)
> 
> b72cb105a5c8e961825b6ec9558c7c7ab4c18070 diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
> index 73f3aee..d1113c5 100644
> --- a/arch/frv/kernel/pm.c
> +++ b/arch/frv/kernel/pm.c
> @@ -14,7 +14,6 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/pm.h>
> -#include <linux/pm_legacy.h>
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/sysctl.h>
> diff --git a/arch/mips/au1000/common/power.c b/arch/mips/au1000/common/power.c
> index 2166b9e..bd854a6 100644
> --- a/arch/mips/au1000/common/power.c
> +++ b/arch/mips/au1000/common/power.c
> @@ -31,7 +31,6 @@
>  
>  #include <linux/init.h>
>  #include <linux/pm.h>
> -#include <linux/pm_legacy.h>
>  #include <linux/sysctl.h>
>  #include <linux/jiffies.h>
>  
> diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
> index bf9290e..fa1f3be 100644
> --- a/arch/x86/kernel/apm_32.c
> +++ b/arch/x86/kernel/apm_32.c
> @@ -218,7 +218,6 @@
>  #include <linux/time.h>
>  #include <linux/sched.h>
>  #include <linux/pm.h>
> -#include <linux/pm_legacy.h>
>  #include <linux/capability.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> diff --git a/include/linux/pm_legacy.h b/include/linux/pm_legacy.h
> deleted file mode 100644
> index 446f4f4..0000000
> --- a/include/linux/pm_legacy.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -#ifndef __LINUX_PM_LEGACY_H__
> -#define __LINUX_PM_LEGACY_H__
> -
> -
> -#ifdef CONFIG_PM_LEGACY
> -
> -/*
> - * Register a device with power management
> - */
> -struct pm_dev __deprecated *
> -pm_register(pm_dev_t type, unsigned long id, pm_callback callback);
> -
> -/*
> - * Send a request to all devices
> - */
> -int __deprecated pm_send_all(pm_request_t rqst, void *data);
> -
> -#else /* CONFIG_PM_LEGACY */
> -
> -static inline struct pm_dev *pm_register(pm_dev_t type,
> -					 unsigned long id,
> -					 pm_callback callback)
> -{
> -	return NULL;
> -}
> -
> -static inline int pm_send_all(pm_request_t rqst, void *data)
> -{
> -	return 0;
> -}
> -
> -#endif /* CONFIG_PM_LEGACY */
> -
> -#endif /* __LINUX_PM_LEGACY_H__ */
> -
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
