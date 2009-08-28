Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZH1Ts0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZH1Ts0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZH1TsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:48:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44312 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZH1TsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:48:24 -0400
Date: Fri, 28 Aug 2009 13:48:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] SR-IOV: correct broken resource alignment calculations
Message-ID: <20090828194825.GM4884@parisc-linux.org>
References: <20090828191714.GI10360@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828191714.GI10360@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Yes, I think that would be preferable.  We have a *LOT* of resources in
the kernel, and the embedded folks would not find it funny if they all
grew in size suddenly.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
