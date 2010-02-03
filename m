Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0BCLKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:10:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51045 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0BCLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:10:05 -0500
Date: Wed, 3 Feb 2010 12:10:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCHv2 07/11] mxc: Add support for the Babbage board
Message-ID: <20100203111003.GP6130@pengutronix.de>
References: <cover.1265173480.git.amit.kucheria@canonical.com> <752ae69adb57d4f73fa011ba380cea1b927b9c8b.1265173480.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <752ae69adb57d4f73fa011ba380cea1b927b9c8b.1265173480.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:05:23 up 113 days, 23:54, 57 users,  load average: 1.30, 1.68,
	1.86
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:16:29PM -0800, Amit Kucheria wrote:
> Babbage is a reference board from Freescale for their i.MX51 SoC.
> 
> Boot tested on a Babbage2.5 board
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/Kconfig               |    6 ++
>  arch/arm/mach-mx5/Makefile              |    2 +
>  arch/arm/mach-mx5/board-mx51_babbage.c  |   99 +++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/common.h |    1 +
>  4 files changed, 108 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/board-mx51_babbage.c
> 
> diff --git a/arch/arm/mach-mx5/Kconfig b/arch/arm/mach-mx5/Kconfig
> index ccd96fd..80a749c 100644
> --- a/arch/arm/mach-mx5/Kconfig
> +++ b/arch/arm/mach-mx5/Kconfig
> @@ -8,4 +8,10 @@ config ARCH_MX51
>  
>  comment "MX5 platforms:"
>  
> +config MACH_MX51_BABBAGE
> +	bool "Support MX51 BABBAGE platforms"
> +	help
> +	  Include support for MX51 Babbage platform. This includes specific
> +	  configurations for the board and its peripherals.
> +
>  endif
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index d74ce4f..e4cf91f 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -5,3 +5,5 @@
>  # Object file lists.
>  obj-y   := cpu.o mm.o clock.o devices.o
>  
> +obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
> +
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c

Uwe started to rename the board files on other i.MX platforms to
mach-*.c. Can you do the same please?

> new file mode 100644
> index 0000000..6cd0e14
> --- /dev/null
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright 2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright (C) 2009-2010 Amit Kucheria <amit.kucheria@canonical.com>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +
> +#include <mach/common.h>
> +#include <mach/hardware.h>
> +#include <mach/imx-uart.h>
> +#include <mach/iomux-mx51.h>
> +
> +#include <asm/irq.h>
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/time.h>
> +
> +#include "crm_regs.h"

Is this needed?

> +#include "devices.h"
> +
> +static struct platform_device *devices[] __initdata = {
> +	&mxc_fec_device,
> +};
> +
> +static struct pad_desc mx51babbage_pads[] = {
> +	/* UART1 */
> +	MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD,
> +	MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD,
> +	MX51_BABBAGE_PAD_UART1_RTS__UART1_RTS,
> +	MX51_BABBAGE_PAD_UART1_CTS__UART1_CTS,
> +
> +	/* UART2 */
> +	MX51_BABBAGE_PAD_UART2_RXD__UART2_RXD,
> +	MX51_BABBAGE_PAD_UART2_TXD__UART2_TXD,
> +
> +	/* UART3 */
> +	MX51_BABBAGE_PAD_EIM_D25__UART3_RXD,
> +	MX51_BABBAGE_PAD_EIM_D26__UART3_TXD,
> +	MX51_BABBAGE_PAD_EIM_D27__UART3_RTS,
> +	MX51_BABBAGE_PAD_EIM_D24__UART3_CTS,
> +};
> +
> +/* Serial ports */
> +#if defined(CONFIG_SERIAL_IMX) || defined(CONFIG_SERIAL_IMX_MODULE)
> +static struct imxuart_platform_data uart_pdata = {
> +	.flags = IMXUART_HAVE_RTSCTS,
> +};
> +
> +static inline void mxc_init_imx_uart(void)
> +{
> +	mxc_register_device(&mxc_uart_device0, &uart_pdata);
> +	mxc_register_device(&mxc_uart_device1, &uart_pdata);
> +	mxc_register_device(&mxc_uart_device2, &uart_pdata);
> +}
> +#else /* !SERIAL_IMX */
> +static inline void mxc_init_imx_uart(void)
> +{
> +}
> +#endif /* SERIAL_IMX */
> +
> +/*
> + * Board specific initialization.
> + */
> +static void __init mxc_board_init(void)
> +{
> +	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
> +					ARRAY_SIZE(mx51babbage_pads));
> +	mxc_init_imx_uart();
> +	platform_add_devices(devices, ARRAY_SIZE(devices));
> +}
> +
> +static void __init mx51_babbage_timer_init(void)
> +{
> +	mx51_clocks_init(32768, 24000000, 22579200, 24576000);
> +}
> +
> +static struct sys_timer mxc_timer = {
> +	.init	= mx51_babbage_timer_init,
> +};
> +
> +MACHINE_START(MX51_BABBAGE, "Freescale MX51 Babbage Board")
> +	/* Maintainer: Amit Kucheria <amit.kucheria@canonical.com> */
> +	.phys_io = MX51_AIPS1_BASE_ADDR,
> +	.io_pg_offst = ((MX51_AIPS1_BASE_ADDR_VIRT) >> 18) & 0xfffc,
> +	.boot_params = PHYS_OFFSET + 0x100,
> +	.map_io = mx51_map_io,
> +	.init_irq = mx51_init_irq,
> +	.init_machine = mxc_board_init,
> +	.timer = &mxc_timer,
> +MACHINE_END
> diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
> index 0a25576..33d4496 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -21,6 +21,7 @@ extern void mx27_map_io(void);
>  extern void mx31_map_io(void);
>  extern void mx35_map_io(void);
>  extern void mx51_map_io(void);
> +extern void mx51_babbage_io_init(void);

Is this function used anywhere? I hope not...

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
