Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbZK1NSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbZK1NSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 08:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZK1NSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 08:18:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:58781 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZK1NSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 08:18:15 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
References: <4B110F79.8080405@redhat.com>
Date: Sat, 28 Nov 2009 14:18:19 +0100
In-Reply-To: <4B110F79.8080405@redhat.com> (Stefan Assmann's message of "Sat,
	28 Nov 2009 12:54:33 +0100")
Message-ID: <m3hbsezt2c.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann <sassmann@redhat.com> writes:

> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -150,7 +150,7 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
>  	if (!strncmp(info->params.host_bus_type, "ISA", 3)) {
>  		p += scnprintf(p, left, "\tbase_address: %x\n",
>  			     info->params.interface_path.isa.base_address);
> -	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
> +	} else if (!strncmp(info->params.host_bus_type, "PCI-X", 4) ||
>  		   !strncmp(info->params.host_bus_type, "PCI", 3)) {

This one looks like a BIOS binary interface so you can't change it.

> --- a/drivers/net/igb/e1000_mac.c
> +++ b/drivers/net/igb/e1000_mac.c
> @@ -1256,7 +1256,7 @@ s32 igb_led_off(struct e1000_hw *hw)
>  }
>
>  /**
> - *  igb_disable_pcie_master - Disables PCI-express master access
> + *  igb_disable_pcie_master - Disables PCIe.press master access
>   *  @hw: pointer to the HW structure

This one needs fixing.

> @@ -2066,7 +2066,7 @@ out:
>  }
>
>  /**
> - *  ixgbe_disable_pcie_master - Disable PCI-express master access
> + *  ixgbe_disable_pcie_master - Disable PCIe.press master access
>   *  @hw: pointer to hardware structure

Same here.

> --- a/drivers/staging/rt3090/common/cmm_mac_pci.c
> +++ b/drivers/staging/rt3090/common/cmm_mac_pci.c
> @@ -1481,7 +1481,7 @@ BOOLEAN RT28xxPciAsicRadioOff(
>  	*/
>  #endif // CONFIG_STA_SUPPORT //
>  //KH Debug:My original codes have the follwoing codes, but currecnt codes do not have it.
> -// Disable for stability. If PCIE Link Control is modified for advance power save, re-covery this code segment.
> +// Disable for stability. If PCIe Link Control is modified for advance power save, re-covery this code segment.

While it has nothing to do with PCIe... You may want to fix it as well.
"follwoing", "currecnt", what does "advance power save" do? What does
the "re-covery this code segment" means? Staging standard.

> --- a/drivers/staging/rt3090/common/rtmp_init.c
> +++ b/drivers/staging/rt3090/common/rtmp_init.c
> @@ -3512,7 +3512,7 @@ int rt28xx_init(
>
>  #ifdef RTMP_MAC_PCI
>  #ifdef PCIE_PS_SUPPORT
> -	/*Iverson patch PCIE L1 issue to make sure that driver can be read,write ,BBP and RF register  at pcie L.1 level */
> +	/*Iverson patch PCIe L1 issue to make sure that driver can be read,write ,BBP and RF register  at pcie L.1 level */
                                                                                                     ^^^^^^^^^^
Should be changed as well I think. "can be read,write", well.

Otherwise, the patch looks IMHO good.
-- 
Krzysztof Halasa
