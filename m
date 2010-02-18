Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0BRE1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:27:12 -0500
Received: from kroah.org ([198.145.64.141]:48070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab0BRE1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:27:10 -0500
Date: Wed, 17 Feb 2010 20:26:26 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux USB <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
	support
Message-ID: <20100218042626.GB11649@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7CAF95.6020306@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 09:10:13PM -0600, Robert Hancock wrote:
> Add a module parameter to allow the user to enable 64-bit DMA support in EHCI,
> which has been forcibly disabled since 2003 - see:
> 
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg17230.html
> 
> At that time the comment was "it'd only matter on a few big Intel boxes anyway",
> however the situation is much different today when many new machines have 4GB
> or more of RAM and IOMMU/SWIOTLB are thus needlessly required for USB transfers.
> For now, the support remains disabled by default and is controlled by an
> allow_64bit module parameter.
> 
> Note that some USB device drivers may require updates to pass the DMA
> capabilities up to their higher layers to avoid unnecessary IOMMU or bounce-
> buffer use (i.e. networking layer NETIF_F_HIGHDMA). Some of these checks were
> disabled by the patch listed above, and more may be required again today.
> However, those previous checks were done incorrectly using dma_supported,
> which checks to see whether a device's DMA mask can be validly set to a given
> mask, not whether its previously set mask will accomodate the mask passed in.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

What is the "advantage" that setting this option would allow people to
do that the code currently does not?  Is such an advantage measurable at
the slow rates that the EHCI driver controls?

Is there any way to dynamically figure out if we can enable this or not?
Adding module paramaters sucks, as they are hard to configure for most
users, and they tend to be ignored.

And are you really ok with enabling this on a system-wide level, and not
on a per-controller level?  Does that work properly on all systems?

And if the system does not support it, and a user enables it, who is
going to support their broken system?  :)

thanks,

greg k-h
