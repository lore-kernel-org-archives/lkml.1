Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYIIQLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYIIQLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYIIQI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:58 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:36002 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbYIIQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:54 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       tony.luck@intel.com, joerg.roedel@amd.com
Subject: [PATCH 0/4] add a helper function, is_buffer_dma_capable()
Date: Wed, 10 Sep 2008 01:06:45 +0900
Message-Id: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a trivial helper function, is_buffer_dma_capable()
and cleans up some IOMMU implementations. This function is to to see
if a memory region is DMA-capable or not with the arguments, the
dma_mask (or coherent_dma_mask) of a device and the address and size
of a memory region. It's useful for IOMMUs that don't do virtual
mappings at all times.

The patch for swiotlb is a bug fix (the rest are just
cleanups). Currently, swiotlb doesn't take account of the size of a
memory region to see if if the memory region is DMA-capable.

=
 arch/x86/kernel/pci-gart_64.c |   16 +++-------------
 arch/x86/kernel/pci-nommu.c   |   10 ++++++----
 include/linux/dma-mapping.h   |    5 +++++
 lib/swiotlb.c                 |   15 ++++++++-------
 4 files changed, 22 insertions(+), 24 deletions(-)


