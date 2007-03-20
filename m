Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXCTSCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXCTSCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965555AbXCTSCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:02:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:41125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbXCTSCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:02:08 -0400
Date: Tue, 20 Mar 2007 11:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Yeisley <dan.yeisley@unisys.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] I/O space boot parameter
Message-ID: <20070320180020.GB21470@suse.de>
References: <1174407505.23830.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174407505.23830.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 12:18:24PM -0400, Daniel Yeisley wrote:
> It has been mentioned before that large systems with a lot of PCI buses
> have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
> to either assign I/O space to all adapters, or only to those that need
> it.  A list of supported adapters that don't need it is kept in the
> BIOS.  When this option is used, the kernel sees the BARs on the
> adapters and still tries to assign I/O space (until it runs out).  I've
> written a patch to implement a boot parameter that tells the kernel not
> to assign I/O space if the BIOS hasn't.  

How prelevant are machines like this?  And why are the BARs on these
devices wrong?

> Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
> ---
> 
> diff -Naur linux-2.6.20-org/Documentation/kernel-parameters.txt linux-2.6.20-new/Documentation/kernel-parameters.txt
> --- linux-2.6.20-org/Documentation/kernel-parameters.txt	2007-02-04 13:44:54.000000000 -0500
> +++ linux-2.6.20-new/Documentation/kernel-parameters.txt	2007-03-05 21:35:15.000000000 -0500
> @@ -1259,6 +1259,7 @@
>  				This sorting is done to get a device
>  				order compatible with older (<= 2.4) kernels.
>  		nobfsort	Don't sort PCI devices into breadth-first order.
> +		noiospace	Do not allocate I/O space unless the BIOS has done so.
>  
>  	pcmv=		[HW,PCMCIA] BadgePAD 4
>  
> diff -Naur linux-2.6.20-org/drivers/pci/pci.c linux-2.6.20-new/drivers/pci/pci.c
> --- linux-2.6.20-org/drivers/pci/pci.c	2007-02-04 13:44:54.000000000 -0500
> +++ linux-2.6.20-new/drivers/pci/pci.c	2007-03-06 00:58:52.000000000 -0500
> @@ -20,6 +20,7 @@
>  #include "pci.h"
>  
>  unsigned int pci_pm_d3_delay = 10;
> +unsigned int noiospace = 0;

pci_no_iospace perhaps?  "noiospace" isn't the best named global
variable...

thanks,

greg k-h
