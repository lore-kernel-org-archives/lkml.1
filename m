Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXJXLeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXJXLeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXJXLeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:34:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60502 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbXJXLeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:34:11 -0400
Message-ID: <471F2DAF.7030800@garzik.org>
Date: Wed, 24 Oct 2007 07:34:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, greg@kroah.com,
       James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 02/11] PCI: add device_dma_parameters support
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024165323F.tomof@acm.org>
In-Reply-To: <20071024165323F.tomof@acm.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> index 463a5a9..54edea2 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -985,8 +985,11 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  
>  	set_dev_node(&dev->dev, pcibus_to_node(bus));
>  	dev->dev.dma_mask = &dev->dma_mask;
> +	dev->dev.dma_parms = &dev->dma_parms;
>  	dev->dev.coherent_dma_mask = 0xffffffffull;
>  
> +	pci_set_dma_max_seg_size(dev, 65536);

this should check the return value of pci_set_dma_max_seg_size(), and do 
something useful.

ACK everything else

