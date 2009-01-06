Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZAFRTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZAFRTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZAFRTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:19:39 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:22716 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZAFRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:19:38 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using MSI-X
Date: Tue, 6 Jan 2009 10:19:04 -0700
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200901042308.42625.rjw@sisk.pl>
In-Reply-To: <200901042308.42625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061019.04488.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 03:08:42 pm Rafael J. Wysocki wrote:
> pcibios_enable_device() and pcibios_disable_device() don't handle
> IRQs for devices that have MSI enabled and it should tread the
> devices with MSI-X enabled in the same way.

There are other places that need similar fixes, too, aren't there?
I see cris, frv, ia64, and a driver or two testing dev->msi_enabled.

> --- linux-2.6.orig/arch/x86/pci/common.c
> +++ linux-2.6/arch/x86/pci/common.c
> @@ -551,14 +551,14 @@ int pcibios_enable_device(struct pci_dev
>  	if ((err = pci_enable_resources(dev, mask)) < 0)
>  		return err;
>  
> -	if (!dev->msi_enabled)
> +	if (!dev->msi_enabled && !dev->msix_enabled)
>  		return pcibios_enable_irq(dev);
>  	return 0;
>  }
>  
>  void pcibios_disable_device (struct pci_dev *dev)
>  {
> -	if (!dev->msi_enabled && pcibios_disable_irq)
> +	if (!dev->msi_enabled && !dev->msix_enabled && pcibios_disable_irq)
>  		pcibios_disable_irq(dev);
>  }
