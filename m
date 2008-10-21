Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYJUD50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYJUD50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 23:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYJUD5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 23:57:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47667 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJUD5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 23:57:16 -0400
Date: Tue, 21 Oct 2008 04:57:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: nagaraj s k <nagaraj.sk@gmail.com>
cc: trivial@kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, nagaraj.krishnappa@thomsonreuters.com
Subject: Re: [PATCH] via-agp.c fixed compilation error and warnings for
 2.6.26
In-Reply-To: <663ba5090810202049i16285109k34fde3ec1c9df319@mail.gmail.com>
Message-ID: <alpine.DEB.0.82.0810210453290.26751@skynet.skynet.ie>
References: <663ba5090810050509g6ce3c25bh40686506b1d35b8f@mail.gmail.com>
 <663ba5090810202049i16285109k34fde3ec1c9df319@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Oct 2008, nagaraj s k wrote:

> Hi All,
> 
> can you please have a look at the patch in the below mail thread, it seems
> like my mails get lost often here. is there any way i can reach the
> moderator or any one who can comment on my work( i know there are thousands
> of patches sent across, i am not the only one).
> 

I saw this patch and couldn't see the problem is was solving. If its just 
a checkpatch.pl run across the file, in parts it makes the file less 
readable, anything splitting stings to avoid the checkpatch.pl stupid 80 
chars warnings isn't anything I'm going to worryabout.

The mail says fixing compilation errors, there are no compilation errors, 
if it fixes checkpatch.pl issues then please say that.

> >          }
> >      }
> > -    printk(KERN_ERR PFX "Unknown aperture size from AGP bridge (0x%x)\n",
> > temp);
> > +    printk(KERN_ERR PFX "Unknown aperture size from AGP
> > +        bridge (0x%x)\n", temp);

Uglier code.

> >      return 0;
> >  }
> >
> > @@ -116,7 +117,8 @@ static int via_fetch_size_agp3(void)
> >      for (i = 0; i < agp_bridge->driver->num_aperture_sizes; i++) {
> >          if (temp == values[i].size_value) {
> >              agp_bridge->previous_size =
> > -                agp_bridge->current_size = (void *) (values + i);
> > +                agp_bridge->current_size =
> > +                     (void *) (values + i);

arguably uglier code.

> >              agp_bridge->aperture_size_idx = i;
> >              return values[i].size;
> >          }
> > @@ -142,11 +144,12 @@ static int via_configure_agp3(void)
> >
> >      /* 1. Enable GTLB in RX90<7>, all AGP aperture access needs to fetch
> >       *    translation table first.
> > -     * 2. Enable AGP aperture in RX91<0>. This bit controls the enabling
> > of the
> > -     *    graphics AGP aperture for the AGP3.0 port.
> > +     * 2. Enable AGP aperture in RX91<0>. This bit controls the
> > +     * enabling of the graphics AGP aperture for the AGP3.0 port.

this is okay.

> >       */
> >      pci_read_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, &temp);
> > -    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp |
> > (3<<7));
> > +    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL,
> > +                         temp | (3<<7));

this one is probably okay.

> >      return 0;
> >  }
> >
> > @@ -156,7 +159,8 @@ static void via_cleanup_agp3(void)
> >      struct aper_size_info_16 *previous_size;
> >
> >      previous_size = A_SIZE_16(agp_bridge->previous_size);
> > -    pci_write_config_byte(agp_bridge->dev, VIA_APSIZE,
> > previous_size->size_value);
> > +    pci_write_config_byte(agp_bridge->dev, VIA_APSIZE,
> > +                previous_size->size_value);
> >  }
> >
> >
> > @@ -165,7 +169,8 @@ static void via_tlbflush_agp3(struct agp
> >      u32 temp;
> >
> >      pci_read_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, &temp);
> > -    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp &
> > ~(1<<7));
> > +    pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL,
> > +                            temp & ~(1<<7));
> >      pci_write_config_dword(agp_bridge->dev, VIA_AGP3_GARTCTRL, temp);
> >  }
> >
> > @@ -421,13 +426,13 @@ static struct agp_device_ids via_agp_dev
> >   * VIA's AGP3 chipsets do magick to put the AGP bridge compliant
> >   * with the same standards version as the graphics card.
> >   */
> > -static void check_via_agp3 (struct agp_bridge_data *bridge)
> > +static void check_via_agp3(struct agp_bridge_data *bridge)
> >  {
> >      u8 reg;
> >
> >      pci_read_config_byte(bridge->dev, VIA_AGPSEL, &reg);
> >      /* Check AGP 2.0 compatibility mode. */
> > -    if ((reg & (1<<1))==0)
> > +    if ((reg & (1<<1)) == 0)
> >          bridge->driver = &via_agp3_driver;
> >  }
> >
> > @@ -445,7 +450,8 @@ static int __devinit agp_via_probe(struc
> >          return -ENODEV;
> >
> >      j = ent - agp_via_pci_table;
> > -    printk (KERN_INFO PFX "Detected VIA %s chipset\n",
> > devs[j].chipset_name);
> > +    printk(KERN_INFO PFX "Detected VIA %s chipset\n",
> > +             devs[j].chipset_name);
> >
> >      bridge = agp_alloc_bridge();
> >      if (!bridge)
> > @@ -461,7 +467,8 @@ static int __devinit agp_via_probe(struc
> >      if (pdev->device == PCI_DEVICE_ID_VIA_8367_0) {
> >          /* Is there a KT400 subsystem ? */
> >          if (pdev->subsystem_device == PCI_DEVICE_ID_VIA_8377_0) {
> > -            printk(KERN_INFO PFX "Found KT400 in disguise as a KT266.\n");
> > +            printk(KERN_INFO PFX "Found KT400 in disguise
> > +                as a KT266.\n");

uglier.

> >              check_via_agp3(bridge);
> >          }
> >      }
> > @@ -491,8 +498,8 @@ static void __devexit agp_via_remove(str
> >
> >  static int agp_via_suspend(struct pci_dev *pdev, pm_message_t state)
> >  {
> > -    pci_save_state (pdev);
> > -    pci_set_power_state (pdev, PCI_D3hot);
> > +    pci_save_state(pdev);
> > +    pci_set_power_state(pdev, PCI_D3hot);
> >
> >      return 0;
> >  }
> > @@ -501,7 +508,7 @@ static int agp_via_resume(struct pci_dev
> >  {
> >      struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
> >
> > -    pci_set_power_state (pdev, PCI_D0);
> > +    pci_set_power_state(pdev, PCI_D0);
> >      pci_restore_state(pdev);
> >
> >      if (bridge->driver == &via_agp3_driver)
> >
> >
> 
