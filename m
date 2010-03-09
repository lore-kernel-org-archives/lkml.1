Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0CIGqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:46:15 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45781 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0CIGqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K1cXSyvCikFFFDY0tq1hii7Ei07g6p/Nb+MlwNhKKBfCs6rsyivPjAPJzRt30jq8NH
         wY1h0ImBFdEWmy2JXanjTmWfC7z0kceCBIagsH248ND8w78Boal/KxRM/trfo7OARwQt
         mxX935jCPgdF5ak50nJZbKnjzmzHsGGDWCDHw=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-8-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-8-git-send-email-viresh.kumar@st.com>
Date: Tue, 9 Mar 2010 07:46:10 +0100
Message-ID: <63386a3d1003082246g2752ccf4ob52d5bb01dfb264c@mail.gmail.com>
Subject: Re: [PATCH 07/11] ST SPEAr: Added source files for SPEAr3xx machine 
	family
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
some smallish comments...

2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:

> (skip some stuff that looks OK...)
> diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
> new file mode 100644
> index 0000000..f529d74
> --- /dev/null
> +++ b/arch/arm/mach-spear3xx/spear3xx.c
> @@ -0,0 +1,118 @@
> +/*
> + * arch/arm/mach-spear3xx/spear3xx.c
> + *
> + * SPEAr3XX machines common source file
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Viresh Kumar<viresh.kumar@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/ptrace.h>
> +#include <linux/io.h>
> +#include <asm/hardware/vic.h>
> +#include <asm/irq.h>
> +#include <asm/mach/arch.h>
> +#include <mach/irqs.h>
> +#include <mach/generic.h>
> +#include <mach/spear.h>
> +#include <plat/gpt.h>
> +
> +/* Add spear3xx machines common devices here */
> +/* uart device registeration */
> +struct amba_device uart_device = {
> +       .dev = {
> +               .init_name = "uart",
> +               },
> +       .res = {
> +               .start = SPEAR3XX_ICM1_UART_BASE,
> +               .end = SPEAR3XX_ICM1_UART_BASE + SPEAR3XX_ICM1_UART_SIZE - 1,
> +               .flags = IORESOURCE_MEM,
> +               },
> +       .irq = {IRQ_UART, NO_IRQ},
> +       .periphid = 0x00041011,
> +};

You're hardcoding the PrimeCell ID to the ARM version, but I suspect
you have an ST derivate with some additional features. If you look in
the PL011 driver in drivers/serial/amba-pl011.c you will probably recognize
the modified PrimeCell IDs for vendor 0x80 (VENDOR_ST) and I think
you might rather need to patch this file with your new periphid and
possibly even implement some new extensions (if there are any).

What value is actually in the ID registers of your cell? (Just
check in some debugger or simply printk() it...)

Apart from this the patch looks OK to me.

Yours,
Linus Walleij
