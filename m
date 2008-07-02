Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYGBP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYGBP4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbYGBPy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:54:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbYGBPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:54:06 -0400
Date: Wed, 2 Jul 2008 08:51:35 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] PCI: make pci_name use dev_name
Message-ID: <20080702155135.GA31159@kroah.com>
References: <20080702153524.GA30318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702153524.GA30318@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 08:35:24AM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Also fixes up the sparc PCI code that was assuming this is not a
> constant.
> 
> This is done in anticipation of removing the bus_id field from struct
> driver.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/sparc64/kernel/pci.c |    2 +-
>  include/linux/pci.h       |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/arch/sparc64/kernel/pci.c
> +++ b/arch/sparc64/kernel/pci.c
> @@ -408,7 +408,7 @@ struct pci_dev *of_create_pci_dev(struct
>  	dev->class = class >> 8;
>  	dev->revision = class & 0xff;
>  
> -	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> +	sprintf(dev->dev.bus_id, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
>  		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
>  
>  	if (ofpci_verbose)
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -977,9 +977,9 @@ static inline void pci_set_drvdata(struc
>  /* If you want to know what to call your pci_dev, ask this function.
>   * Again, it's a wrapper around the generic device.
>   */
> -static inline char *pci_name(struct pci_dev *pdev)
> +static inline const char *pci_name(struct pci_dev *pdev)

Andrew just pointed out to me that this causes a bunch of compiler
warnings to be generated.  I'll go audit the tree to fix them as well
and send you a follow-on patch if that's ok.

thanks,

greg k-h
