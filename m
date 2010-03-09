Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0CIUmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:42:49 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59027 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0CIUmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a8TmJXyMgVUEJehLNv3/JIelLqZ0t1DZWC8+pgfj7XmdlmbiXEVzAN3fCiydHbCavV
         flwGXXq91GJhJmYTn7ZKjp0pzVJqnWRnqIUsOyWUZ+OreK5a3wTB1rB7rVydwOJuw8P+
         SKagfSKrgqTS/w1huFsAkp5eIdaKLI+OS6na8=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
Date: Tue, 9 Mar 2010 21:42:43 +0100
Message-ID: <63386a3d1003091242i5e8786e4n1fe0d83b97d51e3b@mail.gmail.com>
Subject: Re: [PATCH 02/11] ST SPEAr: Added basic header files for SPEAr3xx 
	machine family
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> (...)
> diff --git a/arch/arm/mach-spear3xx/include/mach/debug-macro.S b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
> new file mode 100644
> index 0000000..2f6c5bd
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
> @@ -0,0 +1,38 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/debug-macro.S
> + *
> + * Debugging macro include header spear3xx machine family
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/amba/serial.h>
> +#include <mach/spear.h>
> +
> +               .macro  addruart, rx
> +               mrc     p15, 0, \rx, c1, c0
> +               tst     \rx, #1                                 @ MMU enabled?
> +               moveq   \rx, =SPEAR3XX_ICM1_UART_BASE           @ Physical base
> +               movne   \rx, =VA_SPEAR3XX_ICM1_UART_BASE        @ Virtual base
> +               .endm
> +
> +               .macro  senduart, rd, rx
> +               strb    \rd, [\rx, #UART01x_DR]                 @ ASC_TX_BUFFER
> +               .endm
> +
> +               .macro  waituart, rd, rx
> +1001:          ldr     \rd, [\rx, #UART01x_FR]                 @ FLAG REGISTER
> +               tst     \rd, #UART01x_FR_TXFF                   @ TX_FULL
> +               bne     1001b
> +               .endm
> +
> +               .macro  busyuart, rd, rx
> +1002:          ldr     \rd, [\rx, #UART01x_FR]                 @ FLAG REGISTER
> +               tst     \rd, #UART011_FR_TXFE                   @ TX_EMPTY
> +               beq     1002b
> +               .endm

Apart from that the base offset is named SPEAR6XX_ICM1_UART0_BASE
this is the same file in 3xx and 6xx series. Can you rename the base offset
to SPEARXXX_ICM1_UART0_BASE or something similar in both machines
and move this file to plat-spear/include/plat/debug-macro.S?

You'll probably need mach/include/mach/debug-macro.S to
#include <plat/debug-macro.S> I think.

> diff --git a/arch/arm/mach-spear6xx/include/mach/dma.h b/arch/arm/mach-spear6xx/include/mach/dma.h
> new file mode 100644
> index 0000000..c4afd17
> --- /dev/null
> +++ b/arch/arm/mach-spear6xx/include/mach/dma.h
> @@ -0,0 +1,17 @@
> +/*
> + * arch/arm/mach-spear6xx/include/mach/dma.h
> + *
> + * Generic SPEAr6XX machine family DMA support
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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

Is this file needed? (Perhaps...) Anyway, the name of that #define should
probably be __MACH_DMA_H if it shall match the filepath.

> (...)
> diff --git a/arch/arm/mach-spear3xx/include/mach/misc_regs.h b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
> new file mode 100755
> index 0000000..d83dae9
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
> @@ -0,0 +1,163 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/misc_regs.h
> + *
> + * Miscellaneous registers definitions for SPEAr3xx machine family
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_MACH_MISC_REGS_H
> +#define __ASM_MACH_MISC_REGS_H

It's not __ASM_MACH* really, but just __MACH* if it's supposed to follow
the filename...

> +
> +#include <mach/spear.h>
> +
> +#define MISC_BASE              VA_SPEAR3XX_ICM3_MISC_REG_BASE
> +
> +#define SOC_CFG_CTR            ((unsigned int *)(MISC_BASE + 0x000))
> +#define DIAG_CFG_CTR           ((unsigned int *)(MISC_BASE + 0x004))
> +#define PLL1_CTR               ((unsigned int *)(MISC_BASE + 0x008))
> +#define PLL1_FRQ               ((unsigned int *)(MISC_BASE + 0x00C))
> +#define PLL1_MOD               ((unsigned int *)(MISC_BASE + 0x010))
> +#define PLL2_CTR               ((unsigned int *)(MISC_BASE + 0x014))
> +/* PLL_CTR register masks */
> +#define PLL_ENABLE             2
> +#define PLL_MODE_SHIFT         4
> +#define PLL_MODE_MASK          0x3
> +#define PLL_MODE_NORMAL                0
> +#define PLL_MODE_FRACTION      1
> +#define PLL_MODE_DITH_DSB      2
> +#define PLL_MODE_DITH_SSB      3
> +
> +#define PLL2_FRQ               ((unsigned int *)(MISC_BASE + 0x018))
> +/* PLL FRQ register masks */
> +#define PLL_DIV_N_SHIFT                0
> +#define PLL_DIV_N_MASK         0xFF
> +#define PLL_DIV_P_SHIFT                8
> +#define PLL_DIV_P_MASK         0x7
> +#define PLL_NORM_FDBK_M_SHIFT  24
> +#define PLL_NORM_FDBK_M_MASK   0xFF
> +#define PLL_DITH_FDBK_M_SHIFT  16
> +#define PLL_DITH_FDBK_M_MASK   0xFFFF
> +
> +#define PLL2_MOD               ((unsigned int *)(MISC_BASE + 0x01C))
> +#define PLL_CLK_CFG            ((unsigned int *)(MISC_BASE + 0x020))
> +#define CORE_CLK_CFG           ((unsigned int *)(MISC_BASE + 0x024))
> +/* CORE CLK CFG register masks */
> +#define PLL_HCLK_RATIO_SHIFT   10
> +#define PLL_HCLK_RATIO_MASK    0x3
> +#define HCLK_PCLK_RATIO_SHIFT  8
> +#define HCLK_PCLK_RATIO_MASK   0x3
> +
> +#define PERIP_CLK_CFG          ((unsigned int *)(MISC_BASE + 0x028))
> +/* PERIP_CLK_CFG register masks */
> +#define UART_CLK_SHIFT         4
> +#define UART_CLK_MASK          0x1
> +#define FIRDA_CLK_SHIFT                5
> +#define FIRDA_CLK_MASK         0x3
> +#define GPT0_CLK_SHIFT         8
> +#define GPT1_CLK_SHIFT         11
> +#define GPT2_CLK_SHIFT         12
> +#define GPT_CLK_MASK           0x1
> +#define AUX_CLK_PLL3_MASK      0
> +#define AUX_CLK_PLL1_MASK      1
> +
> +#define PERIP1_CLK_ENB                 ((unsigned int *)(MISC_BASE + 0x02C))
> +/* PERIP1_CLK_ENB register masks */
> +#define UART_CLK_ENB           3
> +#define SSP_CLK_ENB            5
> +#define I2C_CLK_ENB            7
> +#define JPEG_CLK_ENB           8
> +#define FIRDA_CLK_ENB          10
> +#define GPT1_CLK_ENB           11
> +#define GPT2_CLK_ENB           12
> +#define ADC_CLK_ENB            15
> +#define RTC_CLK_ENB            17
> +#define GPIO_CLK_ENB           18
> +#define DMA_CLK_ENB            19
> +#define SMI_CLK_ENB            21
> +#define GMAC_CLK_ENB           23
> +#define USBD_CLK_ENB           24
> +#define USBH_CLK_ENB           25
> +#define C3_CLK_ENB             31
> +
> +#define SOC_CORE_ID            ((unsigned int *)(MISC_BASE + 0x030))
> +#define RAS_CLK_ENB            ((unsigned int *)(MISC_BASE + 0x034))
> +#define PERIP1_SOF_RST                 ((unsigned int *)(MISC_BASE + 0x038))
> +/* PERIP1_SOF_RST register masks */
> +#define JPEG_SOF_RST           8
> +
> +#define SOC_USER_ID            ((unsigned int *)(MISC_BASE + 0x03C))
> +#define RAS_SOF_RST            ((unsigned int *)(MISC_BASE + 0x040))
> +#define PRSC1_CLK_CFG          ((unsigned int *)(MISC_BASE + 0x044))
> +#define PRSC2_CLK_CFG          ((unsigned int *)(MISC_BASE + 0x048))
> +#define PRSC3_CLK_CFG          ((unsigned int *)(MISC_BASE + 0x04C))
> +/* gpt synthesizer register masks */
> +#define GPT_MSCALE_SHIFT       0
> +#define GPT_MSCALE_MASK                0xFFF
> +#define GPT_NSCALE_SHIFT       12
> +#define GPT_NSCALE_MASK                0xF
> +
> +#define AMEM_CLK_CFG           ((unsigned int *)(MISC_BASE + 0x050))
> +#define EXPI_CLK_CFG           ((unsigned int *)(MISC_BASE + 0x054))
> +#define CLCD_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x05C))
> +#define FIRDA_CLK_SYNT                 ((unsigned int *)(MISC_BASE + 0x060))
> +#define UART_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x064))
> +#define GMAC_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x068))
> +#define RAS1_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x06C))
> +#define RAS2_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x070))
> +#define RAS3_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x074))
> +#define RAS4_CLK_SYNT          ((unsigned int *)(MISC_BASE + 0x078))
> +/* aux clk synthesiser register masks for irda to ras4 */
> +#define AUX_EQ_SEL_SHIFT       30
> +#define AUX_EQ_SEL_MASK                1
> +#define AUX_EQ1_SEL            0
> +#define AUX_EQ2_SEL            1
> +#define AUX_XSCALE_SHIFT       16
> +#define AUX_XSCALE_MASK                0xFFF
> +#define AUX_YSCALE_SHIFT       0
> +#define AUX_YSCALE_MASK                0xFFF
> +
> +#define ICM1_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x07C))
> +#define ICM2_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x080))
> +#define ICM3_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x084))
> +#define ICM4_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x088))
> +#define ICM5_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x08C))
> +#define ICM6_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x090))
> +#define ICM7_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x094))
> +#define ICM8_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x098))
> +#define ICM9_ARB_CFG           ((unsigned int *)(MISC_BASE + 0x09C))
> +#define DMA_CHN_CFG            ((unsigned int *)(MISC_BASE + 0x0A0))
> +#define USB2_PHY_CFG           ((unsigned int *)(MISC_BASE + 0x0A4))
> +#define GMAC_CFG_CTR           ((unsigned int *)(MISC_BASE + 0x0A8))
> +#define EXPI_CFG_CTR           ((unsigned int *)(MISC_BASE + 0x0AC))
> +#define PRC1_LOCK_CTR          ((unsigned int *)(MISC_BASE + 0x0C0))
> +#define PRC2_LOCK_CTR          ((unsigned int *)(MISC_BASE + 0x0C4))
> +#define PRC3_LOCK_CTR          ((unsigned int *)(MISC_BASE + 0x0C8))
> +#define PRC4_LOCK_CTR          ((unsigned int *)(MISC_BASE + 0x0CC))
> +#define PRC1_IRQ_CTR           ((unsigned int *)(MISC_BASE + 0x0D0))
> +#define PRC2_IRQ_CTR           ((unsigned int *)(MISC_BASE + 0x0D4))
> +#define PRC3_IRQ_CTR           ((unsigned int *)(MISC_BASE + 0x0D8))
> +#define PRC4_IRQ_CTR           ((unsigned int *)(MISC_BASE + 0x0DC))
> +#define PWRDOWN_CFG_CTR        ((unsigned int *)(MISC_BASE + 0x0E0))
> +#define COMPSSTL_1V8_CFG       ((unsigned int *)(MISC_BASE + 0x0E4))
> +#define COMPSSTL_2V5_CFG       ((unsigned int *)(MISC_BASE + 0x0E8))
> +#define COMPCOR_3V3_CFG        ((unsigned int *)(MISC_BASE + 0x0EC))
> +#define SSTLPAD_CFG_CTR        ((unsigned int *)(MISC_BASE + 0x0F0))
> +#define BIST1_CFG_CTR          ((unsigned int *)(MISC_BASE + 0x0F4))
> +#define BIST2_CFG_CTR          ((unsigned int *)(MISC_BASE + 0x0F8))
> +#define BIST3_CFG_CTR          ((unsigned int *)(MISC_BASE + 0x0FC))
> +#define BIST4_CFG_CTR          ((unsigned int *)(MISC_BASE + 0x100))
> +#define BIST5_CFG_CTR          ((unsigned int *)(MISC_BASE + 0x104))
> +#define BIST1_STS_RES          ((unsigned int *)(MISC_BASE + 0x108))
> +#define BIST2_STS_RES          ((unsigned int *)(MISC_BASE + 0x10C))
> +#define BIST3_STS_RES          ((unsigned int *)(MISC_BASE + 0x110))
> +#define BIST4_STS_RES          ((unsigned int *)(MISC_BASE + 0x114))
> +#define BIST5_STS_RES          ((unsigned int *)(MISC_BASE + 0x118))
> +#define SYSERR_CFG_CTR                 ((unsigned int *)(MISC_BASE + 0x11C))
> +
> +#endif /* __ASM_MACH_MISC_REGS_H */

Personally I like to push down these definitions into the actual driver files,
so that all PLL+CLK stuff goes into clock.c, all GPT stuff into timer.c etc.
It has the convenience of easily finding everything in a single file and
at the same time surely blocking some other driver from poking around
in the same registers.

If you want to keep this file anyway, move it from mach-spear3xx/include/mach
to just mach-spear3xx and include like this: #include "misc_regs.h" and
thus avoid the entire drivers/* tree (etc) from being able to #include
<mach/misc_regs.h>
because surely any machine-specific special driver using these very
machine-specific
registers will be in mach-spear3xx/ anyway.

> (...)
> diff --git a/arch/arm/mach-spear3xx/include/mach/system.h b/arch/arm/mach-spear3xx/include/mach/system.h
> new file mode 100644
> index 0000000..b7bc53f
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/system.h
> @@ -0,0 +1,41 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/system.h
> + *
> + * SPEAr3xx Machine family specific architecture functions
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_MACH_SYSTEM_H
> +#define __ASM_MACH_SYSTEM_H

Again __MACH_SYSTEM_H

> +
> +#include <linux/io.h>
> +#include <linux/sysctl_sp810.h>

In regard to earlier comment:
#include <asm/hardware/sysctl_sp810.h>

> +#include <mach/spear.h>
> +
> +static inline void arch_idle(void)
> +{
> +       /*
> +        * This should do all the clock switching
> +        * and wait for interrupt tricks
> +        */
> +       cpu_do_idle();
> +}
> +
> +static inline void arch_reset(char mode, const char *cmd)
> +{
> +       if (mode == 's') {
> +               /* software reset, Jump into ROM at address 0 */
> +               cpu_reset(0);
> +       } else {
> +               /* hardware reset, Use on-chip reset capability */
> +               sysctl_soft_reset(SPEAR3XX_ICM3_SYS_CTRL_BASE);
> +       }
> +}
> +
> +#endif /* __ASM_MACH_SYSTEM_H */

Again this file is identical to the same file for 6xx. Define a generic
SPEAR_ICM3_SYS_CTRL_BASE or so and move to
plat-spear/include/plat/system.h

(I don't know how this works, perhaps you have to have a skeleton
mach/include/mach/system.h that will just #include <plat/system.h>
for this to work.)

> diff --git a/arch/arm/mach-spear3xx/include/mach/timex.h b/arch/arm/mach-spear3xx/include/mach/timex.h
> new file mode 100644
> index 0000000..29708db
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/timex.h
> @@ -0,0 +1,19 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/timex.h
> + *
> + * SPEAr3XX machine family specific timex definitions
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __ASM_MACH_TIMEX_H
> +#define __ASM_MACH_TIMEX_H

Again __MACH_TIMEX_H

> +
> +#define CLOCK_TICK_RATE                        48000000
> +
> +#endif /* __ASM_MACH_TIMEX_H */
> diff --git a/arch/arm/mach-spear3xx/include/mach/uncompress.h b/arch/arm/mach-spear3xx/include/mach/uncompress.h
> new file mode 100644
> index 0000000..08ec3b1
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/include/mach/uncompress.h
> @@ -0,0 +1,43 @@
> +/*
> + * arch/arm/mach-spear3xx/include/mach/uncompress.h
> + *
> + * Serial port stubs for kernel decompress status messages
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/amba/serial.h>
> +#include <mach/spear.h>
> +
> +#ifndef __ASM_MACH_UNCOMPRESS_H
> +#define __ASM_MACH_UNCOMPRESS_H
> +/*
> + * This does not append a newline
> + */
> +static inline void putc(int c)
> +{
> +       void __iomem *base = (void __iomem *)SPEAR3XX_ICM1_UART_BASE;
> +
> +       while (readl(base + UART01x_FR) & UART01x_FR_TXFF)
> +               barrier();
> +
> +       writel(c, base + UART01x_DR);
> +}
> +
> +static inline void flush(void)
> +{
> +}
> +
> +/*
> + * nothing to do
> + */
> +#define arch_decomp_setup()
> +#define arch_decomp_wdog()
> +
> +#endif /* __ASM_MACH_UNCOMPRESS_H */

Apart from that the base offset is named SPEAR6XX_ICM1_UART0_BASE
this is the same file in 3xx and 6xx series. Can you rename the base offset
to SPEARXXX_ICM1_UART0_BASE or something similar in both machines
and move this file to plat-spear/include/plat/uncompress.h?

(Perhaps mach/include/mach/uncompress.h has to contain a single
#include <plat/uncompress.h> I haven't tested.)

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

Again __MACH_VMALLOC_H

> +
> +#include <mach/memory.h>
> +
> +#define VMALLOC_SIZE           (0x30000000)
> +#define VMALLOC_END            (PAGE_OFFSET + VMALLOC_SIZE)
> +
> +#endif /* __ASM_MACH_VMALLOC_H */

This is exactly the same file as in spear6xx again move to plat-spear.
Might need a single #include <plat/vmalloc.h>

Most comments on this file are in relation to the 6xx header files, so they
apply to that patch as well. Mostly "move to plat-spear" stuff. Just
replace in the proper places.

(The entry-macro is unique for both platforms though!)

Yours,
Linus Walleij
