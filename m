Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZANRtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZANRtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZANRsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:48:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:40298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZANRs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:48:29 -0500
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
 dma_debug_entries
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
In-Reply-To: <20090114093918.e7b0ae46.akpm@linux-foundation.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	 <1231517970-20288-4-git-send-email-joerg.roedel@amd.com>
	 <20090113005118.82f5037b.akpm@linux-foundation.org>
	 <20090114114347.GG8625@elte.hu>
	 <20090114093918.e7b0ae46.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 17:48:15 +0000
Message-Id: <1231955295.25018.5631.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 09:39 -0800, Andrew Morton wrote:
> > this code checks the DMA usage of ~1 million lines of kernel code - all 
> > the DMA using drivers. I think Joerg's feature is hugely relevant as DMA 
> > scribbles are one of the hardest to debug kernel bugs: they can end up in 
> > permanent data corruption or other hard to find bugs. In fact i think his 
> > patchset is rather simple and even having 10 times as much debug code 
> > would pay for its existence in the long run.
> > 
> 
> Have we previously found bugs by other means which this facility would
> have detected?  I don't recall any...

Yes. We've found network driver bugs which only showed up when an IOMMU
has been active -- and were painful to diagnose because they involved
DMA going wrong. It happens when drivers make mistakes with the DMA
mapping APIs.

With this debug facility, we can find such problems on _any_ hardware,
and get a sane report about what's wrong.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

