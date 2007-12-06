Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXLFHe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXLFHe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXLFHeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:34:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXLFHet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:34:49 -0500
Date: Wed, 5 Dec 2007 22:39:40 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
Message-ID: <20071206063940.GA16474@kroah.com>
References: <20071205064116.D849BDE10A@ozlabs.org> <1196911347.7033.15.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196911347.7033.15.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 02:22:27PM +1100, Benjamin Herrenschmidt wrote:
> 
> On Wed, 2007-12-05 at 17:40 +1100, Benjamin Herrenschmidt wrote:
> > The current pci_assign_unassigned_resources() code doesn't work properly
> > on 32 bits platforms with 64 bits resources. The main reason is the use
> > of unsigned long in various places instead of resource_size_t.
> > 
> > This fixes it, along with some tricks to avoid casting to 64 bits on
> > platforms that don't need it in every printk around.
> > 
> > This is a pre-requisite for making powerpc use the generic code instead of
> > its own half-useful implementation.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > This version fixes some stupid warnings when using 32 bits resources
> 
>  ... and has warnings on 64 bits platforms... GRRRR
> 
> This whole issue of printk vs. resource_size_t is a terrible mess :-(
> 
> Part of the problem is that resource_size_t can be either u32 or u64..
> 
> that is  it can be either unsigned int, unsigned long or unsigned long
> long... and we have no way to reliably printk that.

We do this already just fine.  Take a look in the kernel, I think we
just always cast it to long long to be uniform.

> Any clever idea before I start pushing filthy macros up linux/types.h ?

I don't think any macros are needed.

thanks,

greg k-h
