Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYLWEoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYLWEoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYLWEnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:43:50 -0500
Received: from main.gmane.org ([80.91.229.2]:58668 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbYLWEnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:43:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: drivers using the non-PCI dma_set_mask() on PCI devices
Date: Mon, 22 Dec 2008 22:43:33 -0600
Message-ID: <49506C75.8010200@shaw.ca>
References: <200812222132.mBMLWrNU028431@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <200812222132.mBMLWrNU028431@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Several drivers do the following:
> 
> 	struct pci_dev *pdev = ...;
> 	...
> 	if (dma_set_mask(&pdev->dev, mask))
> 		...
> 
> But pdev->dev.dma_mask == &pdev->dma_mask, so this is essentially a
> roundabout way of saying
> 
> 	if (pci_set_dma_mask(pdev, mask))
> 
> except that it bypasses the PCI-specific operations pci_set_dma_mask()
> may do on that platform.
> 
> Drivers doing this include drivers/scsi/aic7xxx/aic79xx_osm_pci.c,
> drivers/scsi/aic7xxxx/aic7xxx_osm_pci.c, drivers/scsi/qla2xxx/qla_os.c,
> drivers/net/wireless/rt2x00/rt2x00pci.c, and drivers/media/video/meye.c.
> 
> Is it considered acceptable that drivers bypass the PCI DMA API on
> PCI devices like this, or are these drivers in error?
> 
> I'm doing some work on an embedded platform (ARM IXP4xx) with some
> PCI DMA restrictions. To handle these the platform provides its own
> versions of pci_set_dma_mask() and pci_set_consistent_dma_mask(),
> but its dma_set_mask() currently does not do anything PCI-specific.
> The question is: should dma_set_mask() have PCI knowledge or not?

AFAIK pci_set_dma_mask is somewhat deprecated, and dma_set_mask should 
be used instead. If the platform fails to do what's needed when 
dma_set_mask is called on a PCI device then it would seem the platform 
code is in error.

