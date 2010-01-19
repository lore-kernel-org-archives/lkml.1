Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009Ab0ASLAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0ASLAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695Ab0ASLAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:00:46 -0500
Received: from bamako.nerim.net ([62.4.17.28]:49450 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0ASLAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:00:45 -0500
Date: Tue, 19 Jan 2010 12:00:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2.6.32.3] i2c-i801: SMBus patch for Intel Cougar Point
 DeviceIDs
Message-ID: <20100119120040.14444393@hyperion.delvare>
In-Reply-To: <201001121658.54044.seth.heasley@intel.com>
References: <201001121658.54044.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

Please note that the i2c mailing list address has changed.

On Tue, 12 Jan 2010 16:58:53 -0800, Seth Heasley wrote:
> This patch adds the Intel Cougar Point (PCH) SMBus Controller DeviceIDs.

This comment suggests that Cougar Point == PCH, while the comments in
i2c-i801 suggests otherwise. Who is right?

> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c.orig	2010-01-06 15:07:45.000000000 -0800
> +++ linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c	2010-01-07 13:10:28.000000000 -0800
> @@ -41,7 +41,8 @@
>    Tolapai               0x5032     32     hard     yes     yes     yes
>    ICH10                 0x3a30     32     hard     yes     yes     yes
>    ICH10                 0x3a60     32     hard     yes     yes     yes
> -  PCH                   0x3b30     32     hard     yes     yes     yes
> +  3400/5 Series (PCH)   0x3b30     32     hard     yes     yes     yes
> +  CPT                   0x1c22     32     hard     yes     yes     yes
>  
>    Features supported by this driver:
>    Software PEC                     no
> @@ -578,6 +579,7 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CPT_SMBUS) },
>  	{ 0, }
>  };
>  
> @@ -707,6 +709,7 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_4:
>  	case PCI_DEVICE_ID_INTEL_ICH10_5:
>  	case PCI_DEVICE_ID_INTEL_PCH_SMBUS:
> +	case PCI_DEVICE_ID_INTEL_CPT_SMBUS:
>  		i801_features |= FEATURE_I2C_BLOCK_READ;
>  		/* fall through */
>  	case PCI_DEVICE_ID_INTEL_82801DB_3:
> --- linux-2.6.32.3/drivers/i2c/busses/Kconfig.orig	2010-01-06 15:07:45.000000000 -0800
> +++ linux-2.6.32.3/drivers/i2c/busses/Kconfig	2010-01-07 13:10:28.000000000 -0800
> @@ -98,6 +98,7 @@
>  	    Tolapai
>  	    ICH10
>  	    PCH
> +	    CPT

It might be clear for you that "CPT" means "Cougar Point", but for the
reader it may not be. I'd rather list the full chip name. Same in
i2c-i801.c's header comment, BTW.

>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-i801.

Documentation/i2c/busses/i2c-i801 needs to be updated as well.

-- 
Jean Delvare
