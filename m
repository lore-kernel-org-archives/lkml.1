Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0CESP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:15:28 -0500
Received: from mga10.intel.com ([192.55.52.92]:59362 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755188Ab0CESP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:15:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,588,1262592000"; 
   d="scan'208";a="546458100"
Date: Fri, 5 Mar 2010 19:16:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH -next] mfd/lpc_sch: fix related depends/selects, fix
 build error
Message-ID: <20100305181632.GB5615@sortiz.org>
References: <20100305181358.9adfe089.sfr@canb.auug.org.au>
 <4B9142AA.9040801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9142AA.9040801@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Fri, Mar 05, 2010 at 09:43:06AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> LPC_SCH is selected by GPI_SCH and I2C_ISCH, even when PCI is not
> enabled, but LPC_SCH depends on PCI, so make GPI_SCH and I2C_ISCH
> also depend on PCI.
> 
> Those 2 selects also need to select what LPC_SCH selects,
> since kconfig does not follow selects.
Thanks, patch applied.

Cheers,
Samuel.


> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/gpio/Kconfig       |    3 ++-
>  drivers/i2c/busses/Kconfig |    2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> --- linux-next-20100305.orig/drivers/gpio/Kconfig
> +++ linux-next-20100305/drivers/gpio/Kconfig
> @@ -87,7 +87,8 @@ config GPIO_VR41XX
>  
>  config GPIO_SCH
>  	tristate "Intel SCH GPIO"
> -	depends on GPIOLIB
> +	depends on GPIOLIB && PCI
> +	select MFD_CORE
>  	select LPC_SCH
>  	help
>  	  Say yes here to support GPIO interface on Intel Poulsbo SCH.
> --- linux-next-20100305.orig/drivers/i2c/busses/Kconfig
> +++ linux-next-20100305/drivers/i2c/busses/Kconfig
> @@ -105,6 +105,8 @@ config I2C_I801
>  
>  config I2C_ISCH
>  	tristate "Intel SCH SMBus 1.0"
> +	depends on PCI
> +	select MFD_CORE
>  	select LPC_SCH
>  	help
>  	  Say Y here if you want to use SMBus controller on the Intel SCH
> 
> -- 
> ~Randy

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
