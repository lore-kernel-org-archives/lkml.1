Return-Path: <linux-kernel-owner+w=401wt.eu-S1423142AbXDXVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423142AbXDXVk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423143AbXDXVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:40:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:43844 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423142AbXDXVk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:40:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218928516:sNHT42408485"
Date: Tue, 24 Apr 2007 14:38:35 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: David Miller <davem@davemloft.net>
Cc: ak@suse.de, ashok.raj@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Message-ID: <20070424213835.GB31920@linux-os.sc.intel.com>
References: <200704242133.16219.ak@suse.de> <20070424203304.GB27911@linux-os.sc.intel.com> <200704242312.54738.ak@suse.de> <20070424.142351.62664098.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424.142351.62664098.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 02:23:51PM -0700, David Miller wrote:
> From: Andi Kleen <ak@suse.de>
> Date: Tue, 24 Apr 2007 23:12:54 +0200
> 
> > We already have a couple of other IOMMU architectures who essentially have the same
> > problem. Have you checked how they solve this?
> 
> Sparc64, for one, only uses 32-bit IOMMU addresses.  And we simply
> don't try to handle the funny devices at all, in fact we can't
> handle the ones that want mappings only in the low 16MB for
> example since the hardware IOMMU window usually starts in the
> middle of the 32-bit PCI address space.
> 
> We do it both because that's faster due to Single Address Cycles, as
> mentioned, and also because that's simply is where the hardware's
> IOMMU window is.  You can't use 64-bit IOMMU addresses even if you
> wanted to on sparc64.
> 
> My suggestion would be to allocate top-down in the 32-bit IOMMU space.
> 
> That might work, but my gut feeling is that this won't be sufficient
> and we'll need some kind of device driver initiated reservation
> mechanism for the <16MB et al. weird stuff.

Its not clear if we have a very generic device breakage.. most devices
on these platforms are going to be more recent, (except maybe some
legacy fd)... 

Maybe we should wait to fix unless we are certain if there are more of them
that breaks in these platforms.

We could choose to use the generic 1-1 for those weird cases, since the 
driver does ensure today that physical mem is low 16M, then we could
just turn on 1-1 domain for such devices without breaking any.
