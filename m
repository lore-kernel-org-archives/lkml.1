Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZCIVUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZCIVUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZCIVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:19:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZCIVT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:19:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCIe portdrv: eliminate double kfree in remove path
Date: Mon, 9 Mar 2009 22:19:37 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090309180815.GH32589@ldl.fc.hp.com>
In-Reply-To: <20090309180815.GH32589@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903092219.37414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Alex Chiang wrote:
> Commit 55633af3 (PCIe portdrv: Use driver data to simplify code)
> added a kfree of the driver private data in pcie_port_device_remove
> but forgot to remove the old kfree from pcie_portdrv_remove.

Ah, sorry for that, it resulted in quite a lot of debugging work for you. :-(

> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by; Rafael J. Wysocki <rjw@sisk.pl>

> ---
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index a6fee6c..f2368b1 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -93,7 +93,6 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
>  static void pcie_portdrv_remove (struct pci_dev *dev)
>  {
>  	pcie_port_device_remove(dev);
> -	kfree(pci_get_drvdata(dev));
>  }
>  
>  static int error_detected_iter(struct device *device, void *data)
> --
