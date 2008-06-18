Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbYFRHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbYFRHZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbYFRHY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:24:58 -0400
Received: from smtp.movial.fi ([62.236.91.34]:45310 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbYFRHY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:24:56 -0400
Message-ID: <4858B892.8080909@movial.fi>
Date: Wed, 18 Jun 2008 10:26:10 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: zhenyu.z.wang@intel.com
CC: Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGP] intel_agp: Add support for Intel 4 series chipsets
References: <20080618052300.GA16715@zhen-devel.sh.intel.com>
In-Reply-To: <20080618052300.GA16715@zhen-devel.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhenyu Wang wrote:
> Dave, here's the patch against current git master.
> 
> Thanks.
> 
> [AGP] intel_agp: Add support for Intel 4 series chipsets
> 
> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
> ---
>  drivers/char/agp/intel-agp.c |   82 ++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 72 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index eeea50a..76731db 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -34,6 +34,12 @@
>  #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
>  #define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
>  #define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
> +#define PCI_DEVICE_ID_INTEL_IGD_E_HB        0x2E00
> +#define PCI_DEVICE_ID_INTEL_IGD_E_IG        0x2E02
> +#define PCI_DEVICE_ID_INTEL_Q45_HB          0x2E10
> +#define PCI_DEVICE_ID_INTEL_Q45_IG          0x2E12
> +#define PCI_DEVICE_ID_INTEL_G45_HB          0x2E20
> +#define PCI_DEVICE_ID_INTEL_G45_IG          0x2E22
>  
>  /* cover 915 and 945 variants */
>  #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
> @@ -55,6 +61,10 @@
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q33_HB)
>  
> +#define IS_G4X	(agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_E_HB || \
> +                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q45_HB || \
> +                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB)
> +
>  extern int agp_memory_reserved;
>  
>  
> @@ -80,8 +90,12 @@ extern int agp_memory_reserved;
>  #define I915_PTEADDR	0x1C
>  #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
>  #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
> -#define G33_GMCH_GMS_STOLEN_128M       (0x8 << 4)
> -#define G33_GMCH_GMS_STOLEN_256M       (0x9 << 4)
> +#define G33_GMCH_GMS_STOLEN_128M        (0x8 << 4)
> +#define G33_GMCH_GMS_STOLEN_256M        (0x9 << 4)
> +#define INTEL_GMCH_GMS_STOLEN_96M	(0xa << 4)
> +#define INTEL_GMCH_GMS_STOLEN_160M	(0xb << 4)
> +#define INTEL_GMCH_GMS_STOLEN_224M	(0xc << 4)
> +#define INTEL_GMCH_GMS_STOLEN_352M	(0xd << 4)
>  #define I915_IFPADDR    0x60
>  
>  /* Intel 965G registers */
> @@ -504,6 +518,10 @@ static void intel_i830_init_gtt_entries(void)
>  			size = 512;
>  		}
>  		size += 4;
> +	} else if (IS_G4X) {
> +		/* On 4 Series hardware, GTT stolen is seperate from graphics

You have a spelling error here. Should be "separate".

Thanks,
Dmitri
