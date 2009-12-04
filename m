Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZLDLau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZLDLau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZLDLat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:30:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49370 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbZLDLas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:30:48 -0500
Date: Fri, 4 Dec 2009 12:30:54 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       linux-arm-kernel@lists.infradead.org, valentin.longchamp@epfl.ch,
       daniel@caiaq.de, grant.likely@secretlab.ca, r.herring@freescale.com
Subject: Re: [RFC][PATCH 08/10] arm: mxc: Add IO multiplexing support for
	FEC
Message-ID: <20091204113054.GO15126@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <dbab65547b41b82719df19067b50db9c82eeb6d6.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbab65547b41b82719df19067b50db9c82eeb6d6.1259893118.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:29:09 up 53 days, 18 min, 72 users,  load average: 10.51,
	6.67, 3.80
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:08AM +0200, Amit Kucheria wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Setup correct multiplexing in order to use the FEC ethernet device on the
> Babbage board.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/board-mx51_babbage.c    |   43 +++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++
>  2 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index a1bc9c4..cefcb90 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -33,6 +33,8 @@ extern void __init mx51_babbage_io_init(void);
>  #define MX51_UART2_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_PUE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
>  #define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
>  
> +#define MX51_FEC_PAD_CTRL	(PAD_CTL_DRV_VOT_HIGH | PAD_CTL_DRV_HIGH)
> +
>  /* UART1 */
>  #define MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD	IOMUX_PAD(0x618, 0x228,	IOMUX_CONFIG_ALT0, 0x9e4,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
>  #define MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD	IOMUX_PAD(0x61C, 0x22C, IOMUX_CONFIG_ALT0, 0x0,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
> @@ -52,6 +54,28 @@ extern void __init mx51_babbage_io_init(void);
>  
>  #define MX51_BABBAGE_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 1, (PAD_CTL_SRE_SLOW | PAD_CTL_DSE_MED | PAD_CTL_PUS_100K_UP |  PAD_CTL_HYS))
>  
> +/* FEC */
> +#define MX51_BABBAGE_PAD_EIM_EB2__MDIO		IOMUX_PAD(0x468, 0x0d4, IOMUX_CONFIG_ALT3, 0x954,   0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_CS3__MDC		IOMUX_PAD(0x524, 0x13C, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_CS3__RDATA3	IOMUX_PAD(0x480, 0x0ec, IOMUX_CONFIG_ALT3, 0x964,   0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_CS2__RDATA2	IOMUX_PAD(0x47c, 0x0e8, IOMUX_CONFIG_ALT3, 0x960,   0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_EB3__RDATA1	IOMUX_PAD(0x46c, 0x0d8, IOMUX_CONFIG_ALT3, 0x95c,   0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_RB6__RDATA0	IOMUX_PAD(0x5DC, 0x134, IOMUX_CONFIG_ALT1, 0x958, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_D11__RX_DV	IOMUX_PAD(0x54C, 0x164, IOMUX_CONFIG_ALT2, 0x96c, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_RB3__RX_CLK	IOMUX_PAD(0x504, 0x128, IOMUX_CONFIG_ALT1, 0x968, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_CS4__RX_ER		IOMUX_PAD(0x484, 0x0f0, IOMUX_CONFIG_ALT3, 0x970,   0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_RDY_INT__TX_CLK	IOMUX_PAD(0x538, 0x150, IOMUX_CONFIG_ALT1, 0x974, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_CS7__TX_EN	IOMUX_PAD(0x534, 0x14C, IOMUX_CONFIG_ALT1, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_D8__TDATA0	IOMUX_PAD(0x558, 0x170, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_CS4__TDATA1	IOMUX_PAD(0x528, 0x140, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_CS5__TDATA2	IOMUX_PAD(0x52C, 0x144, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_CS6__TDATA3	IOMUX_PAD(0x530, 0x148, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_NANDF_RB2__COL		IOMUX_PAD(0x500, 0x124, IOMUX_CONFIG_ALT1, 0x94c, 0, MX51_FEC_PAD_CTRL)
> +#define MX51_BABBAGE_PAD_EIM_CS5__CRS		IOMUX_PAD(0x52C, 0x144, IOMUX_CONFIG_ALT3, 0x950, 0, MX51_FEC_PAD_CTRL)

These are generic and should go to iomux-mx51.h

> +
> +
> +
> +
>  static struct platform_device *devices[] __initdata = {
>  	&mxc_fec_device,
>  };
> @@ -72,6 +96,25 @@ static struct pad_desc mx51babbage_pads[] = {
>  	MX51_BABBAGE_PAD_EIM_D26__UART3_TXD,
>  	MX51_BABBAGE_PAD_EIM_D27__UART3_RTS,
>  	MX51_BABBAGE_PAD_EIM_D24__UART3_CTS,
> +
> +	/* FEC */
> +	MX51_BABBAGE_PAD_EIM_EB2__MDIO,
> +	MX51_BABBAGE_PAD_NANDF_CS3__MDC,
> +	MX51_BABBAGE_PAD_EIM_CS3__RDATA3,
> +	MX51_BABBAGE_PAD_EIM_CS2__RDATA2,
> +	MX51_BABBAGE_PAD_EIM_EB3__RDATA1,
> +	MX51_BABBAGE_PAD_NANDF_RB6__RDATA0,
> +	MX51_BABBAGE_PAD_NANDF_D11__RX_DV,
> +	MX51_BABBAGE_PAD_NANDF_RB3__RX_CLK,
> +	MX51_BABBAGE_PAD_EIM_CS4__RX_ER,
> +	MX51_BABBAGE_PAD_NANDF_RDY_INT__TX_CLK,
> +	MX51_BABBAGE_PAD_NANDF_CS7__TX_EN,
> +	MX51_BABBAGE_PAD_NANDF_D8__TDATA0,
> +	MX51_BABBAGE_PAD_NANDF_CS4__TDATA1,
> +	MX51_BABBAGE_PAD_NANDF_CS5__TDATA2,
> +	MX51_BABBAGE_PAD_NANDF_CS6__TDATA3,
> +	MX51_BABBAGE_PAD_NANDF_RB2__COL,
> +	MX51_BABBAGE_PAD_EIM_CS5__CRS	,
>  };
>  
>  /* Serial ports */
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> index 8c351d6..78c71f0 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> @@ -89,6 +89,14 @@ struct pad_desc {
>  #define PAD_CTL_SRE_FAST		(1 << 0)
>  #define PAD_CTL_SRE_SLOW		(0 << 0)
>  
> +#define PAD_CTL_DRV_LOW			(0 << 1)
> +#define PAD_CTL_DRV_MEDIUM		(1 << 1)
> +#define PAD_CTL_DRV_HIGH		(2 << 1)
> +#define PAD_CTL_DRV_MAX			(3 << 1)

These are duplicates of PAD_CTL_SRE_* defined directly above.

> +
> +#define PAD_CTL_DRV_VOT_LOW		(0 << 13)
> +#define PAD_CTL_DRV_VOT_HIGH		(1 << 13)
> +
>  /*
>   * setups a single pad:
>   * 	- reserves the pad so that it is not claimed by another driver
> -- 
> 1.6.3.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
