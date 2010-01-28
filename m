Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150Ab0A1WI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0A1WI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928Ab0A1WI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:08:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33726 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab0A1WIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:08:55 -0500
Date: Thu, 28 Jan 2010 22:08:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
Message-ID: <20100128220835.GA23471@n2100.arm.linux.org.uk>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:40:38PM +0900, Magnus Damm wrote:
> --- 0001/arch/arm/Kconfig
> +++ work/arch/arm/Kconfig	2010-01-20 18:59:55.000000000 +0900
> @@ -740,6 +740,11 @@ config ARCH_U8500
>  	help
>  	  Support for ST-Ericsson's Ux500 architecture
>  
> +config ARCH_SHMOBILE
> +	bool "Renesas SH-Mobile"
> +	help
> +	  Support for Renesas's SH-Mobile ARM platforms
> +

The entries in this choice menu are sorted by option text - please
place your new option appropriately to avoid conflicts.

>  endchoice
>  
>  source "arch/arm/mach-aaec2000/Kconfig"
> @@ -851,6 +856,8 @@ source "arch/arm/mach-versatile/Kconfig"
>  
>  source "arch/arm/mach-w90x900/Kconfig"
>  
> +source "arch/arm/mach-shmobile/Kconfig"

Ditto, except ordered alphabetically by filename.

> +static struct sh_timer_config cmt10_platform_data = {
> +	.name = "CMT10",
> +	.channel_offset = 0x10,
> +	.timer_bit = 0,
> +	.clk = "r_clk",

I guess you can't do a lot about this because of arch/sh, but over in ARM
land, we use clkdev to get the clock primerily by the device name rather
than a string passed around; this is how the clk API is meant to be used.
