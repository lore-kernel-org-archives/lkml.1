Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYH2IC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYH2IC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYH2ICK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:02:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47745 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYH2ICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:02:08 -0400
Date: Fri, 29 Aug 2008 10:01:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2.6.27-rc4][RESEND] irq: irq and pci_ids patch for Intel
 Ibex Peak DeviceIDs
Message-ID: <20080829100153.5ccdf0ae@hyperion.delvare>
In-Reply-To: <200808281540.59657.seth.heasley@intel.com>
References: <200808281540.59657.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 15:40:59 -0700, Seth Heasley wrote:
> This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.
> 
> The LPC Controller ID is set by Firmware within the range of 0x3b00-3b1f.  This range is included in pci_ids.h using min and max values, and irq.c now has code to handle the range (in lieu of 32 additions to a SWITCH statement).
> 
> The SMBus Controller ID is a fixed-value and will not change.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6/include/linux/pci_ids.h.orig	2008-08-27 11:54:07.000000000 -0700
> +++ linux-2.6/include/linux/pci_ids.h	2008-08-28 14:59:35.000000000 -0700
> @@ -2428,9 +2428,9 @@
>  #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
>  #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
>  #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
> -#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b10
> -#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b11
> -#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b30
> +#define PCI_DEVICE_ID_INTEL_PCH_LPC_MIN	0x3b00
> +#define PCI_DEVICE_ID_INTEL_PCH_LPC_MAX	0x3b1f
> +#define PCI_DEVICE_ID_INTEL_PCH_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>  #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
>  #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5
> --- linux-2.6/arch/x86/pci/irq.c.orig	2008-08-27 11:53:13.000000000 -0700
> +++ linux-2.6/arch/x86/pci/irq.c	2008-08-28 15:12:04.000000000 -0700
> @@ -590,13 +590,20 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_2:
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> -	case PCI_DEVICE_ID_INTEL_PCH_0:
> -	case PCI_DEVICE_ID_INTEL_PCH_1:
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
>  		return 1;
>  	}
> +
> +	if ((device >= PCI_DEVICE_ID_INTEL_PCH_LPC_MIN) && 
> +		(device <= PCI_DEVICE_ID_INTEL_PCH_LPC_MAX)) {
> +		r->name = "PIIX/ICH";
> +		r->get = pirq_piix_get;
> +		r->set = pirq_piix_set;
> +		return 1;
> +	}
> +
>  	return 0;
>  }
>  

Looks good to me, thanks for doing that.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
