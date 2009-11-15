Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZKOMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZKOMXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZKOMXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:23:04 -0500
Received: from sh.osrg.net ([192.16.179.4]:46551 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbZKOMXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:23:03 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       joerg.roedel@amd.com
Subject: [PATCH 0/3] x86: kill global bad_dma_address variable
Date: Sun, 15 Nov 2009 21:19:51 +0900
Message-Id: <1258287594-8777-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 15 Nov 2009 21:22:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against -tip.

This patchset kills bad_dma_address variable, the old mechanism to
enable IOMMU drivers to make dma_mapping_error() work in IOMMU's
specific way.

bad_dma_address variable was introduced to enable IOMMU drivers to
make dma_mapping_error() work in IOMMU's specific way. However, it
can't handle systems that use both swiotlb and HW IOMMU. SO we
introduced dma_map_ops->mapping_error to solve that case.

Keeping those two mechanisms is pointless. Let's remove the old one.

=
 arch/x86/include/asm/dma-mapping.h |    5 +++--
 arch/x86/kernel/amd_iommu.c        |   21 ++++++++++-----------
 arch/x86/kernel/pci-calgary_64.c   |   31 +++++++++++++------------------
 arch/x86/kernel/pci-dma.c          |    3 ---
 arch/x86/kernel/pci-gart_64.c      |   18 +++++++++++++-----
 arch/x86/kernel/pci-nommu.c        |    2 +-
 6 files changed, 40 insertions(+), 40 deletions(-)



