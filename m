Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYHDQIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYHDQIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYHDQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4736 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbYHDQFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:20 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K533C0-04-0UA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] introduce generic iommu_num_pages function
Date: Mon, 4 Aug 2008 18:04:40 +0200
Message-ID: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0458 (UTC) FILETIME=[D3B03620:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches re-introduces the iommu_num_pages function so that it
can be used by each architecture specific IOMMU implementations. The series
also changes IOMMU implementations for X86, Alpha, PowerPC and UltraSparc. The
other implementations are not yet changed because the modifications required
are not obvious and I can't test them on real hardware.

The first three patches are to make this series bisectable.  The changes are
compile-tested on the architectures changed and runtime tested in X86 only. The
patches apply cleanly to latest linus/master tree.

Joerg

git diff --stat linus/master:

 arch/alpha/kernel/pci_iommu.c      |   17 +++++------------
 arch/powerpc/kernel/iommu.c        |   23 +++++++----------------
 arch/sparc64/kernel/iommu.c        |    7 ++++---
 arch/sparc64/kernel/iommu_common.h |   14 ++------------
 arch/sparc64/kernel/pci_sun4v.c    |    7 ++++---
 arch/x86/kernel/amd_iommu.c        |    9 +++++----
 arch/x86/kernel/pci-calgary_64.c   |   18 ++++--------------
 arch/x86/kernel/pci-dma.c          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    8 ++++----
 include/asm-x86/iommu.h            |    2 +-
 include/linux/iommu-helper.h       |    2 ++
 lib/iommu-helper.c                 |    9 +++++++++
 12 files changed, 49 insertions(+), 71 deletions(-)



