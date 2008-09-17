Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYIQQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYIQQxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYIQQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:09 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:64129 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYIQQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:08 -0400
X-BigFish: VPS-34(z21eW5edJz14ffO936eQ4015Mzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMW5-03-U8R-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org
Subject: [PATCH 0/23] AMD IOMMU 2.6.28 updates for review
Date: Wed, 17 Sep 2008 18:52:34 +0200
Message-ID: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 17 Sep 2008 16:52:57.0885 (UTC) FILETIME=[D64F04D0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the patch series with all 2.6.28 updates I currently have for
the AMD IOMMU driver. The highlights in this series are the
implementation of lazy IOTLB flushing which increases performance and
code for AMD IOMMU event handling. Any events the hardware will send are
now visible. There are also a lot of minor fixes and cleanups which came
up during code review and LKML discussions from various persons. The
patches are relative to current tip/master branch.
Please review.

Here is the shortlog and the diffstat:

FUJITA Tomonori (1):
      AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent

Joerg Roedel (22):
      AMD IOMMU: check for invalid device pointers
      AMD IOMMU: move TLB flushing to the map/unmap helper functions
      AMD IOMMU: implement lazy IO/TLB flushing
      AMD IOMMU: add branch hints to completion wait checks
      AMD IOMMU: align alloc_coherent addresses properly
      AMD IOMMU: add event buffer allocation
      AMD IOMMU: save pci segment from ACPI tables
      AMD IOMMU: save pci_dev instead of devid
      AMD IOMMU: add MSI interrupt support
      AMD IOMMU: add event handling code
      AMD IOMMU: enable event logging
      AMD IOMMU: allow IO page faults from devices
      AMD IOMMU: add dma_supported callback
      AMD IOMMU: don't assing preallocated protection domains to devices
      AMD IOMMU: some set_device_domain cleanups
      AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
      AMD IOMMU: simplify dma_mask_to_pages
      AMD IOMMU: free domain bitmap with its allocation order
      AMD IOMMU: remove unnecessary cast to u64 in the init code
      AMD IOMMU: calculate IVHD size with a function
      AMD IOMMU: use cmd_buf_size when freeing the command buffer
      add AMD IOMMU tree to MAINTAINERS file

 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |    1 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/kernel/amd_iommu.c         |  301 +++++++++++++++++++++++++++++------
 arch/x86/kernel/amd_iommu_init.c    |  194 ++++++++++++++++++++--
 include/asm-x86/amd_iommu.h         |    3 +
 include/asm-x86/amd_iommu_types.h   |   64 +++++++-
 7 files changed, 497 insertions(+), 72 deletions(-)

Thanks,

Joerg



