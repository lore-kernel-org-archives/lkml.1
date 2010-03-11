Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0CKKdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:33:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57124 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0CKKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:33:45 -0500
Date: Thu, 11 Mar 2010 10:33:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com
Subject: Re: [PATCH 02/11] ST SPEAr: Added basic header files for SPEAr3xx
	machine family
Message-ID: <20100311103321.GB16376@n2100.arm.linux.org.uk>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:37:32AM +0530, Viresh KUMAR wrote:
> diff --git a/arch/arm/mach-spear3xx/include/mach/dma.h b/arch/arm/mach-spear3xx/include/mach/dma.h
> new file mode 100644
> index 0000000..9b93bc6
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/dma.h
> @@ -0,0 +1,18 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/dma.h
> + *
> + * Generic DMA support for SPEAr3xx machine family
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_ARCH_DMA_H
> +#define __ASM_ARCH_DMA_H
> +
> +#endif /* __ASM_ARCH_DMA_H */
> +

You don't need to provide this file if you don't use it.

> diff --git a/arch/arm/mach-spear3xx/include/mach/vmalloc.h b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
> new file mode 100644
> index 0000000..4f236f3
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
> @@ -0,0 +1,22 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/vmalloc.h
> + *
> + * Defining Vmalloc area for SPEAr3xx machine family
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_MACH_VMALLOC_H
> +#define __ASM_MACH_VMALLOC_H
> +
> +#include <mach/memory.h>
> +
> +#define VMALLOC_SIZE		(0x30000000)
> +#define VMALLOC_END		(PAGE_OFFSET + VMALLOC_SIZE)

Don't define it like this - define VMALLOC_END to be the maximum virtual
address which you can permit the vmalloc area to extend to - which is
generally the start of your peripheral mappings.

It's rather pointless defining it in terms of PAGE_OFFSET, because this
can vary, whereas the start of your peripheral mappings tends to be
fixed.
