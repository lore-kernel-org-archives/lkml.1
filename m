Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbZEAAcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbZEAAcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbZEAASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:18:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932889AbZEAASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:18:52 -0400
Date: Thu, 30 Apr 2009 17:14:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: rdunlap@xenotime.net, fenghua.yu@intel.com, dwmw2@infradead.org,
       mingo@elte.hu, torvalds@linux-foundation.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
Message-Id: <20090430171417.b7adab90.akpm@linux-foundation.org>
In-Reply-To: <20090501000509.GA20743@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<20090430162905.d232be29.akpm@linux-foundation.org>
	<49FA3650.8030307@xenotime.net>
	<20090501000509.GA20743@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 17:05:10 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> > > : --- a/arch/x86/kernel/pci-dma.c
> > > : +++ b/arch/x86/kernel/pci-dma.c
> > > : @@ -160,6 +160,8 @@ again:
> > > :         return page_address(page);
> > > :  }
> > > :  
> > > : +extern int iommu_pass_through;
> > > : +
> > > 
> > > Which is wrong and unnecessary - the variable was already declared in a
> > > header file.
> > > 
> > > scripts/checkpatch.pl would have warned you about this error, but
> > > apparently neither you nor the people who reviewed or merged the patch
> > > bother to use it.
> 
> Actually checkpatch.pl doesn't report anything wrong with this statement.

Running 4ed0d3e6c64cfd9ba4ceb2099b10d1cf8ece4320 through checkpatch produces
the below output:

WARNING: externs should be avoided in .c files
#83: FILE: arch/x86/kernel/pci-dma.c:163:
+extern int iommu_pass_through;

WARNING: suspect code indent for conditional statements (8, 15)
#108: FILE: arch/x86/kernel/pci-swiotlb.c:74:
+       if ((!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN) ||
[...]
               swiotlb = 1;

