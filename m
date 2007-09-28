Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbXI1XDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbXI1XDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbXI1XDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:03:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33187 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbXI1XDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:03:32 -0400
Date: Fri, 28 Sep 2007 15:49:26 -0700
From: Greg KH <greg@kroah.com>
To: Maarten Bressers <mbres@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compiler warnings for 2.6.23-rc8 on x86_64
Message-ID: <20070928224926.GA12531@kroah.com>
References: <20070928205630.38562652FE@smtp.gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928205630.38562652FE@smtp.gentoo.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 08:56:30PM +0000, Maarten Bressers wrote:
> This (trivial) patch fixes two compiler warnings for 2.6.23-rc8 on x86_64,
> use of deprecated function pci_find_device() and a section mismatch.
> Build log and .config file included.
> 
> Signed-off by: Maarten Bressers <mbres@gentoo.org>
> 
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index c6e79d0..0eb7e9e 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -96,7 +96,7 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
>  {
>  	struct pci_dev *dev = NULL;
>  
> -	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> +	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>  		if (dev->bus->number == bus && dev->devfn == devfn)
>  			return dev;
>  	}

This is not a trivial patch, it changes the behavior of the code and is
buggy.

Please read the documentationfor pci_get_device() on how to use it
properly.  It can not be used in pci_find_slot() as the reference
counting will be all wrong.  You need to just work to get rid of
pci_find_slot() and then remove the whole function to get rid of the
warning :)

> -EXPORT_SYMBOL(pci_find_device);
> -EXPORT_SYMBOL(pci_find_slot);

What about the modules that want to use these functions?  Are they all
now gone?  If so, just drop the whole function.

thanks,

greg k-h
