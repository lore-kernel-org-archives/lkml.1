Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZCIAaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZCIAaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 20:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZCIA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 20:29:59 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:4352 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZCIA36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 20:29:58 -0400
Date: Sun, 8 Mar 2009 18:29:55 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: rjw@sisk.pl
Subject: Re: [PATCH] PCIe: portdrv: call pci_disable_device during remove
Message-ID: <20090309002955.GA23137@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, rjw@sisk.pl
References: <20090308044649.GC3575@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308044649.GC3575@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to cc Rafael on this one.

/ac

* Alex Chiang <achiang@hp.com>:
> The PCIe port driver calls pci_enable_device when registering
> ports, but never calls pci_disable_device during removal.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> This patch is against jbarnes's linux-next branch.
> ---
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 5a5bfe7..e399825 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -473,6 +473,7 @@ void pcie_port_device_remove(struct pci_dev *dev)
>  	struct pcie_port_data *port_data = pci_get_drvdata(dev);
>  
>  	device_for_each_child(&dev->dev, NULL, remove_iter);
> +	pci_disable_device(dev);
>  
>  	switch (port_data->port_irq_mode) {
>  	case PCIE_PORT_MSIX_MODE:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
