Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZJWFvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZJWFvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZJWFvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:51:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:37778 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZJWFve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:51:34 -0400
Date: Fri, 23 Oct 2009 14:51:12 +0900
To: chrisw@sous-sol.org
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
 failures
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091023012158.177308035@sequoia.sous-sol.org>
References: <20091023012158.177308035@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091023145054P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 23 Oct 2009 14:51:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 18:21:58 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> This short series gives us the ability to allocate the swiotlb and then
> conditionally free it if we discover it isn't needed.  This allows us to
> put swiotlb to use when the hw iommu fails to initialize properly.
> 
> This needs some changes to the bootmem allocator to give the ability to
> free reserved bootmem directly to the page allocator after bootmem is
> torn down.

The concept sounds fine but the third patch doesn't look correct.

Seems that the third patch doesn't take into account enabling both hw
iommu and swiotlb (Calgary does and I guess VT-d and AMD need that
too). Also (iommu_detected && !dma_ops) trick doesn't work for
Calgary, IIRC. The third patch also makes the dma startup code more
complicated.

I have half-baked patches to clean up the dma startup code supporting
the concept. I can work on the top of the first and second
patches. They need to be CC'ed to the memory people and ACKs, don't
they?


Thanks,
