Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYIHMAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYIHMAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIHMA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:00:29 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52690 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIHMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:00:28 -0400
X-BigFish: VPS-34(zz1418M1432R98dR1805M936fQzz10d3izz2f39iz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6VLCH-03-DE7-01
Date: Mon, 8 Sep 2008 14:00:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] fix exhaustion of ZONE_DMA with swiotlb (in x86 tree)
Message-ID: <20080908120017.GI3189@amd.com>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Sep 2008 12:00:17.0768 (UTC) FILETIME=[75F20E80:01C911AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 06:10:09PM +0900, FUJITA Tomonori wrote:
> This patchset (against tip/master) fixes the problem that swiotlb
> exhausts ZONE_DMA:
> 
> http://lkml.org/lkml/2008/8/31/16
> 
> The root problem is that swiotlb_alloc_coherent always use ZONE_DMA,
> which is fine for IA64 but not for x86_64.
> 
> This patchset makes the callers set up the gfp flags so that
> swiotlb_alloc_coherent can stop playing with the gfp flags.
> 
> I think that it would be better to remove the allocation code in
> swiotlb_alloc_coherent theoretically (what swiotlb should do is taking
> care of the swiotlb memory. And swiotlb_alloc_coherent is not useful
> since we use it only when we can't allocate memory reachable by the
> device or we are in out of memory). But that code works for both x86
> and IA64 so it's not so bad, I guess.
> 
> #1 is for IA64, #2-4 for x86, and #5 is for swiotlb.

Cool :-)

This is much better than our last two tries to solve this problem. Doing
no gfp handling at all in swiotlb_alloc_coherent is a nice and clean
solution.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

