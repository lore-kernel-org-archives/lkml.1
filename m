Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZCHKRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZCHKRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCHKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:17:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33370 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZCHKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:17:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCIe: portdrv: call pci_disable_device during remove
Date: Sun, 8 Mar 2009 11:17:19 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, matthew@wil.cx, stable@kernel.org,
       "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090308023547.GB3575@ldl.fc.hp.com>
In-Reply-To: <20090308023547.GB3575@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903081117.19660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Alex Chiang wrote:
> The PCIe port driver calls pci_enable_device() during probe but
> never calls pci_disable_device() during remove.
> 
> Cc: stable@kernel.org
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> This is a bug in the original PCIe port driver code, and should
> be backported to the .27 and .28 stable series.
> 
> The implementation of the PCIe port driver is different in
> linux-next, and I have a different patch for that.

Fine with me.

> ---
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 248b4db..5ea566e 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -103,6 +103,7 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
>  static void pcie_portdrv_remove (struct pci_dev *dev)
>  {
>  	pcie_port_device_remove(dev);
> +	pci_disable_device(dev);
>  	kfree(pci_get_drvdata(dev));
>  }

Thanks,
Rafael
