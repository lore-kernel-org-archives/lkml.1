Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZH1Tpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZH1Tpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZH1Tpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:45:38 -0400
Received: from kroah.org ([198.145.64.141]:42885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZH1Tph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:45:37 -0400
Date: Fri, 28 Aug 2009 12:43:38 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] SR-IOV: correct broken resource alignment calculations
Message-ID: <20090828194338.GB16479@kroah.com>
References: <20090828191714.GI10360@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828191714.GI10360@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 12:17:14PM -0700, Chris Wright wrote:
> An SR-IOV capable device includes an SR-IOV PCIe capability which
> describes the Virtual Function (VF) BAR requirements.  A typical SR-IOV
> device can support multiple VFs whose BARs must be in a contiguous region,
> effectively an array of VF BARs.  The BAR reports the size requirement
> for a single VF.  We calculate the full range needed by simply multiplying
> the VF BAR size with the number of possible VFs and create a resource
> spanning the full range.
> 
> This all seems sane enough except it artificially inflates the alignment
> requirement for the VF BAR.  The VF BAR need only be aligned to the size
> of a single BAR not the contiguous range of VF BARs.  This can cause us
> to fail to allocate resources for the BAR despite the fact that we
> actually have enough space.
> 
> This patch adds a support for a new resource alignment type,
> IORESOURCE_VSIZEALIGN, and allows struct resource to keep track of the
> size requirements of a VF BAR which are smaller than the full resource
> size.  This could also be done all within the PCI layer w/out bloating
> struct resource or using the last available bit for alignment types.
> 
> Comments?
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Yu Zhao <yu.zhao@intel.com>
> Cc: stable@kernel.org

This is a new feature, which seems to be odd to have it sent to stable
:)

Does this fix reported problems in the "wild"?

Other than that minor procedural thing, the patch looks good to me.

thanks,

greg k-h
