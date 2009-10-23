Return-Path: <linux-kernel-owner+w=401wt.eu-S1751329AbZJWBWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbZJWBWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZJWBWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:22:47 -0400
Received: from sous-sol.org ([216.99.217.87]:52776 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbZJWBWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:22:43 -0400
Message-Id: <20091023012158.177308035@sequoia.sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 22 Oct 2009 18:21:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init failures
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series gives us the ability to allocate the swiotlb and then
conditionally free it if we discover it isn't needed.  This allows us to
put swiotlb to use when the hw iommu fails to initialize properly.

This needs some changes to the bootmem allocator to give the ability to
free reserved bootmem directly to the page allocator after bootmem is
torn down.

 arch/x86/include/asm/swiotlb.h |    4 ++
 arch/x86/kernel/pci-dma.c      |    4 +-
 arch/x86/kernel/pci-swiotlb.c  |   27 +++++++++---
 include/linux/bootmem.h        |    1 +
 include/linux/swiotlb.h        |    3 +
 lib/swiotlb.c                  |   10 ++++
 mm/bootmem.c                   |   98 +++++++++++++++++++++++++++++++---------
 7 files changed, 118 insertions(+), 29 deletions(-)

thanks,
-chris

