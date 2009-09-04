Return-Path: <linux-kernel-owner+w=401wt.eu-S933403AbZIDJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbZIDJi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbZIDJi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:26 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6388 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbZIDJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:22 -0400
X-SpamScore: 11
X-BigFish: VPS11(zba6lz3c4lzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXFR-01-4LY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Passthrough support for AMD-IOMMU (AMD-Vi)
Date: Fri, 4 Sep 2009 11:36:26 +0200
Message-ID: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0201 (UTC) FILETIME=[36633310:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches implement iommu=pt support for AMD IOMMU (AMD-Vi). If
this option is passed on the kernel command line, the AMD-Vi driver will not
register itself as the dma_ops backend and allows all devices unlimited access
to main memory as long as no other kernel part (currently only KVM will do so)
assigns the device to another domain using the IOMMU-API.

Joerg

Diffstat:


 arch/x86/include/asm/amd_iommu.h       |    1 +
 arch/x86/include/asm/amd_iommu_types.h |    4 +
 arch/x86/kernel/amd_iommu.c            |  140 +++++++++++++++++++++++++++----
 arch/x86/kernel/amd_iommu_init.c       |    8 ++-
 arch/x86/kernel/pci-dma.c              |    9 ++-
 5 files changed, 142 insertions(+), 20 deletions(-)

Shortlog:

Joerg Roedel (8):
      x86/dma: Mark iommu_pass_through as __read_mostly
      x86/amd-iommu: Add core functions for pd allocation/freeing
      x86/amd-iommu: Add passthrough mode initialization functions
      x86/amd-iommu: Fix device table write order
      x86/amd-iommu: Align locking between attach_device and detach_device
      x86/amd-iommu: Make sure a device is assigned in passthrough mode
      x86/amd-iommu: Don't detach device from pt domain on driver unbind
      x86/amd-iommu: Initialize passthrough mode when requested


