Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYJVLtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYJVLtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYJVLsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:48:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59966 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYJVLst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:48:49 -0400
Date: Wed, 22 Oct 2008 05:48:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: nagaraj s k <nagaraj.sk@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, trivial@kernel.org, greg@kroah.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       nagaraj.krishnappa@thomsonreuters.com
Subject: Re: [PATCH] via-agp.c fixed compilation error and warnings for 2.6.26
Message-ID: <20081022114832.GD26094@parisc-linux.org>
References: <663ba5090810050509g6ce3c25bh40686506b1d35b8f@mail.gmail.com> <663ba5090810202049i16285109k34fde3ec1c9df319@mail.gmail.com> <alpine.DEB.0.82.0810210453290.26751@skynet.skynet.ie> <20081021042353.GL26184@parisc-linux.org> <663ba5090810202137w750a1cc9m815489e92a2c6d94@mail.gmail.com> <663ba5090810220353g7da53f0mb57fe2129da5a8b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <663ba5090810220353g7da53f0mb57fe2129da5a8b2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 04:23:37PM +0530, nagaraj s k wrote:
> I tried making the changes as you rightly pointed out, please comment on
> this patch and let me know if this still needs some work.

I don't know what you're doing, but the original version of this file
has tabs.  You seem to have converted this to 4-space indents somehow.

> @@ -29,14 +29,15 @@ static int via_fetch_size(void)
>      values = A_SIZE_8(agp_bridge->driver->aperture_sizes);
>      pci_read_config_byte(agp_bridge->dev, VIA_APSIZE, &temp);
>      for (i = 0; i < agp_bridge->driver->num_aperture_sizes; i++) {
> -        if (temp == values[i].size_value) {
> -            agp_bridge->previous_size =
> -                agp_bridge->current_size = (void *) (values + i);
> +        if (temp == values[i].size_value)
> +            continue;
> +        agp_bridge->previous_size = agp_bridge->current_size =
> +                values + i;
>              agp_bridge->aperture_size_idx = i;
>              return values[i].size;
>          }
> -    }
> -    printk(KERN_ERR PFX "Unknown aperture size from AGP bridge (0x%x)\n",
> temp);
> +    dev_err(&agp_bridge->dev->dev, "Unknown AGP aperture size 0x%x\n",
> +                temp);
>      return 0;
>  }
> 
> @@ -82,9 +83,9 @@ static void via_tlbflush(struct agp_memo
>      u32 temp;
> 
>      pci_read_config_dword(agp_bridge->dev, VIA_GARTCTRL, &temp);
> -    temp |= (1<<7);
> +    temp |= (1 << 7);
>      pci_write_config_dword(agp_bridge->dev, VIA_GARTCTRL, temp);
> -    temp &= ~(1<<7);
> +    temp &= ~(1 << 7);
>      pci_write_config_dword(agp_bridge->dev, VIA_GARTCTRL, temp);
>  }
> 
> @@ -114,13 +115,15 @@ static int via_fetch_size_agp3(void)
>      temp &= 0xfff;
> 
>      for (i = 0; i < agp_bridge->driver->num_aperture_sizes; i++) {
> -        if (temp == values[i].size_value) {
> -            agp_bridge->previous_size =
> -                agp_bridge->current_size = (void *) (values + i);
> +        if (temp == values[i].size_value)
> +            continue;
> +        agp_bridge->previous_size = agp_bridge->current_size =
> +                    values + i;
>              agp_bridge->aperture_size_idx = i;
>              return values[i].size;
>          }
> -    }
> +    dev_err(&agp_bridge->dev->dev, "Unknown AGP aperture size 0x%x\n",
> +                        temp);
>      return 0;
>  }
> 
> @@ -141,12 +144,13 @@ static int via_configure_agp3(void)
>          agp_bridge->gatt_bus_addr & 0xfffff000);
> 
>      /* 1. Enable GTLB in RX90<7>, all AGP aperture access needs to fetch
> -     *    translation table first.
> -     * 2. Enable AGP aperture in RX91<0>. This bit controls the enabling of
> the
> -     *    graphics AGP aperture for the AGP3.0 port.
> +     * translation table first.
> +     * 2. Enable AGP aperture in RX91<0>. This bit controls the
> +     * enabling of the graphics AGP aperture for the AGP3.0 port.

You've deleted the spaces at the beginning of the line here.  Don't do
that.

>       */
>      pci_read_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, &temp);
> -    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp |
> (3<<7));
> +    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL,
> +                         temp | (3 << 7));
>      return 0;
>  }
> 
> @@ -156,7 +160,8 @@ static void via_cleanup_agp3(void)
>      struct aper_size_info_16 *previous_size;
> 
>      previous_size = A_SIZE_16(agp_bridge->previous_size);
> -    pci_write_config_byte(agp_bridge->dev, VIA_APSIZE,
> previous_size->size_value);
> +    pci_write_config_byte(agp_bridge->dev, VIA_APSIZE,
> +                previous_size->size_value);
>  }
> 
> 
> @@ -165,7 +170,8 @@ static void via_tlbflush_agp3(struct agp
>      u32 temp;
> 
>      pci_read_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, &temp);
> -    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp &
> ~(1<<7));
> +    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL,
> +                            temp & ~(1 << 7));
>      pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp);
>  }
> 
> @@ -421,13 +427,13 @@ static struct agp_device_ids via_agp_dev
>   * VIA's AGP3 chipsets do magick to put the AGP bridge compliant
>   * with the same standards version as the graphics card.
>   */
> -static void check_via_agp3 (struct agp_bridge_data *bridge)
> +static void check_via_agp3(struct agp_bridge_data *bridge)
>  {
>      u8 reg;
> 
>      pci_read_config_byte(bridge->dev, VIA_AGPSEL, &reg);
>      /* Check AGP 2.0 compatibility mode. */
> -    if ((reg & (1<<1))==0)
> +    if ((reg & (1 << 1)) == 0)
>          bridge->driver = &via_agp3_driver;
>  }
> 
> @@ -445,7 +451,8 @@ static int __devinit agp_via_probe(struc
>          return -ENODEV;
> 
>      j = ent - agp_via_pci_table;
> -    printk (KERN_INFO PFX "Detected VIA %s chipset\n",
> devs[j].chipset_name);
> +    printk(KERN_INFO PFX "Detected VIA %s chipset\n",
> +             devs[j].chipset_name);
> 
>      bridge = agp_alloc_bridge();
>      if (!bridge)
> @@ -461,7 +468,8 @@ static int __devinit agp_via_probe(struc
>      if (pdev->device == PCI_DEVICE_ID_VIA_8367_0) {
>          /* Is there a KT400 subsystem ? */
>          if (pdev->subsystem_device == PCI_DEVICE_ID_VIA_8377_0) {
> -            printk(KERN_INFO PFX "Found KT400 in disguise as a KT266.\n");
> +            printk(KERN_INFO PFX "Found KT400 in disguise
> +                as a KT266.\n");

No.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
