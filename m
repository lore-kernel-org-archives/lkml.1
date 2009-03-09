Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZCIV2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZCIV2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZCIV2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:28:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZCIV2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:28:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCIe: portdrv: call pci_disable_device during remove
Date: Mon, 9 Mar 2009 22:28:33 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090308044649.GC3575@ldl.fc.hp.com>
In-Reply-To: <20090308044649.GC3575@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903092228.33983.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Alex Chiang wrote:
> The PCIe port driver calls pci_enable_device when registering
> ports, but never calls pci_disable_device during removal.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

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
