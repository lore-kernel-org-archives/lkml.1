Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZH1UAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZH1UAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZH1UAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:00:04 -0400
Received: from sous-sol.org ([216.99.217.87]:42149 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752122AbZH1UAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:00:03 -0400
Date: Fri, 28 Aug 2009 12:58:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] SR-IOV: correct broken resource alignment calculations
Message-ID: <20090828195823.GJ10360@sequoia.sous-sol.org>
References: <20090828191714.GI10360@sequoia.sous-sol.org> <20090828194338.GB16479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828194338.GB16479@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Fri, Aug 28, 2009 at 12:17:14PM -0700, Chris Wright wrote:
> > An SR-IOV capable device includes an SR-IOV PCIe capability which
> > describes the Virtual Function (VF) BAR requirements.  A typical SR-IOV
> > device can support multiple VFs whose BARs must be in a contiguous region,
> > effectively an array of VF BARs.  The BAR reports the size requirement
> > for a single VF.  We calculate the full range needed by simply multiplying
> > the VF BAR size with the number of possible VFs and create a resource
> > spanning the full range.
> > 
> > This all seems sane enough except it artificially inflates the alignment
> > requirement for the VF BAR.  The VF BAR need only be aligned to the size
> > of a single BAR not the contiguous range of VF BARs.  This can cause us
> > to fail to allocate resources for the BAR despite the fact that we
> > actually have enough space.
> > 
> > This patch adds a support for a new resource alignment type,
> > IORESOURCE_VSIZEALIGN, and allows struct resource to keep track of the
> > size requirements of a VF BAR which are smaller than the full resource
> > size.  This could also be done all within the PCI layer w/out bloating
> > struct resource or using the last available bit for alignment types.
> > 
> > Comments?
> > 
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Matthew Wilcox <matthew@wil.cx>
> > Cc: Yu Zhao <yu.zhao@intel.com>
> > Cc: stable@kernel.org
> 
> This is a new feature, which seems to be odd to have it sent to stable
> :)

Yeah, it's broken now (and shipped in 2.6.30).

> Does this fix reported problems in the "wild"?


Depending on card firwmware, yeah, I've hit this problem.


thanks,
-chris
