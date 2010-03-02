Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0CBIK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:10:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39590 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0CBIKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:10:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B8CC7BD.5020206@jp.fujitsu.com>
Date: Tue, 02 Mar 2010 17:09:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100216 Thunderbird/3.0.2
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] ACPI, APEI, PCIE AER, use general HEST table parsing
 in AER firmware_first setup
References: <1267494902-7193-1-git-send-email-ying.huang@intel.com> <1267494902-7193-2-git-send-email-ying.huang@intel.com>
In-Reply-To: <1267494902-7193-2-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/02 10:55), Huang Ying wrote:
> ... The firmware_first setup code is moved from PCI core to
> AER driver too, because it is only AER related.
(snip)
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index c843a79..cc527c1 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -858,6 +858,8 @@ void aer_delete_rootport(struct aer_rpc *rpc)
>   */
>  int aer_init(struct pcie_device *dev)
>  {
> +	aer_set_firmware_first(dev);
> +
>  	if (dev->port->aer_firmware_first) {
>  		dev_printk(KERN_DEBUG, &dev->device,
>  			   "PCIe errors handled by platform firmware.\n");
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2a94309..ccfaf19 100644
(snip)
> @@ -935,7 +928,6 @@ int pci_setup_device(struct pci_dev *dev)
>  	dev->multifunction = !!(hdr_type & 0x80);
>  	dev->error_state = pci_channel_io_normal;
>  	set_pcie_port_type(dev);
> -	set_pci_aer_firmware_first(dev);
>  
>  	list_for_each_entry(slot, &dev->bus->slots, list)
>  		if (PCI_SLOT(dev->devfn) == slot->number)

The aer_init() will be called for root ports, but not for end point
devices or so on.  So please remain the firmware_first setup code in
PCI core.  Otherwise endpoint drivers will get success on call of
pci_enable_pcie_error_reporting() regardless of the firmware first.


Thanks,
H.Seto

