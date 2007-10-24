Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXJXNl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXJXNl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbXJXNlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:41:39 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53679 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbXJXNli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:41:38 -0400
Date: Wed, 24 Oct 2007 22:41:12 +0900
To: jeff@garzik.org
Cc: tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, greg@kroah.com,
       James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 02/11] PCI: add device_dma_parameters support
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <471F2DAF.7030800@garzik.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
	<20071024165323F.tomof@acm.org>
	<471F2DAF.7030800@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071024224217K.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 07:34:07 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > index 463a5a9..54edea2 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -985,8 +985,11 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
> >  
> >  	set_dev_node(&dev->dev, pcibus_to_node(bus));
> >  	dev->dev.dma_mask = &dev->dma_mask;
> > +	dev->dev.dma_parms = &dev->dma_parms;
> >  	dev->dev.coherent_dma_mask = 0xffffffffull;
> >  
> > +	pci_set_dma_max_seg_size(dev, 65536);
> 
> this should check the return value of pci_set_dma_max_seg_size(), and do 
> something useful.
> 
> ACK everything else

Thanks.

I wasn't sure about what to do. Should pci_device_add fail in case of
pci_set_dma_max_seg_size failure or just should we print warning?
