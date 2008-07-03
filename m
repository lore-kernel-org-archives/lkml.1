Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYGCNCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYGCNCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYGCNC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:02:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbYGCNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:02:25 -0400
Date: Thu, 03 Jul 2008 03:35:56 -0700 (PDT)
Message-Id: <20080703.033556.167121752.davem@davemloft.net>
To: gregkh@suse.de
Cc: davem@daveloft.net, kay.sievers@vrfy.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: fix up bus_id changes in sparc core code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080702153651.GB30318@kroah.com>
References: <20080702153651.GB30318@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 2 Jul 2008 08:36:51 -0700

> --- a/arch/sparc64/kernel/pci.c
> +++ b/arch/sparc64/kernel/pci.c
> @@ -408,7 +408,7 @@ struct pci_dev *of_create_pci_dev(struct
>  	dev->class = class >> 8;
>  	dev->revision = class & 0xff;
>  
> -	sprintf(dev->dev.bus_id, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> +	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
>  		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
>  
>  	if (ofpci_verbose)

Those lines read:

	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));

in Linus's current tree.

What are you patching against?  That first argument is not
dev->dev.bus_id in any tree I have sitting here, it's always
pci_name() :-)
