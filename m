Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZDWHTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZDWHTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZDWHTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:19:09 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:3411 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZDWHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:19:08 -0400
Message-ID: <49F0166B.9060006@zankel.net>
Date: Thu, 23 Apr 2009 00:19:07 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Johannes Weiner <jw@emlix.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>
Subject: Re: [patch 09/12] xtensa: allow platform and variant to initialize
 own irq chips
References: <1239702080-14355-1-git-send-email-jw@emlix.com> <1239702080-14355-10-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-10-git-send-email-jw@emlix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

What
Johannes Weiner wrote:
> From: Daniel Glöckner <dg@emlix.com>
> 
> diff --git a/arch/xtensa/include/asm/irq.h b/arch/xtensa/include/asm/irq.h
> index dfac82d..c3c10a7 100644
> --- a/arch/xtensa/include/asm/irq.h
> +++ b/arch/xtensa/include/asm/irq.h
> @@ -11,21 +11,36 @@
>  #ifndef _XTENSA_IRQ_H
>  #define _XTENSA_IRQ_H
>  
> +#include <linux/init.h>
>  #include <platform/hardware.h>
>  #include <variant/core.h>
>  
> -#ifdef CONFIG_VARIANT_IRQ_SWITCH
>  #include <variant/irq.h>
> -#else
> +#ifndef CONFIG_VARIANT_IRQ_SWITCH
>  static inline void variant_irq_enable(unsigned int irq) { }
>  static inline void variant_irq_disable(unsigned int irq) { }
>  #endif

What was the reason for this change? We shouldn't require all processor 
variants to provide an irq.h header file, unless required (and we 
wouldn't need to add the following files)

> diff --git a/arch/xtensa/variants/dc232b/include/variant/irq.h b/arch/xtensa/variants/dc232b/include/variant/irq.h
> new file mode 100644
> index 0000000..070b9f5
> --- /dev/null
> +++ b/arch/xtensa/variants/dc232b/include/variant/irq.h
> @@ -0,0 +1,4 @@
> +#ifndef __XTENSA_VARIANT_IRQ_H
> +#define __XTENSA_VARIANT_IRQ_H
> +
> +#endif
> diff --git a/arch/xtensa/variants/fsf/include/variant/irq.h b/arch/xtensa/variants/fsf/include/variant/irq.h
> new file mode 100644
> index 0000000..070b9f5
> --- /dev/null
> +++ b/arch/xtensa/variants/fsf/include/variant/irq.h
> @@ -0,0 +1,4 @@
> +#ifndef __XTENSA_VARIANT_IRQ_H
> +#define __XTENSA_VARIANT_IRQ_H
> +
> +#endif

Since you are at it, can you change __XTENSA_S6000_IRQ_H to 
_XTENSA_S6000_IRQ_H (single 'underscore' prefix).

> diff --git a/arch/xtensa/variants/s6000/include/variant/irq.h b/arch/xtensa/variants/s6000/include/variant/irq.h
> index fa031cb..55403d1 100644
> --- a/arch/xtensa/variants/s6000/include/variant/irq.h
> +++ b/arch/xtensa/variants/s6000/include/variant/irq.h
> @@ -2,6 +2,7 @@
>  #define __XTENSA_S6000_IRQ_H
>  
>  #define NO_IRQ		(-1)
> +#define VARIANT_NR_IRQS 8 /* GPIO interrupts */
>  
>  extern void variant_irq_enable(unsigned int irq);
>  extern void variant_irq_disable(unsigned int irq);

Thanks,
-Chris
