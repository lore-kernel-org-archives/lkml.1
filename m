Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYISKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYISKHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYISKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:07:25 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:36654 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYISKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:07:23 -0400
X-BigFish: VPS-22(z21eW5edJz936eQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7FTFZ-04-CL7-01
Date: Fri, 19 Sep 2008 12:07:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU updates for 2.6.28
Message-ID: <20080919100711.GH24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 10:07:11.0577 (UTC) FILETIME=[7B9ABC90:01C91A3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull the updates for the AMD IOMMU driver for the 2.6.28 merge
window. Most of the patches had been sent to LKML for review and got
comments. One patch touches the GART driver and was added after an
objection with a patch previously in this series. Please pull.

The following changes since commit 74546a8cd9a4e2c26a15a534f0be2f9cc08ae675:
  Ingo Molnar (1):
        Revert "fix warning in: "x86: HPET_MSI Initialise per-cpu HPET timers""

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-updates-2.6.28

FUJITA Tomonori (1):
      AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent

Joerg Roedel (24):
      AMD IOMMU: check for invalid device pointers
      AMD IOMMU: move TLB flushing to the map/unmap helper functions
      x86: move GART TLB flushing options to generic code
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
      AMD IOMMU: don't assign preallocated protection domains to devices
      AMD IOMMU: some set_device_domain cleanups
      AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
      AMD IOMMU: simplify dma_mask_to_pages
      AMD IOMMU: free domain bitmap with its allocation order
      AMD IOMMU: remove unnecessary cast to u64 in the init code
      AMD IOMMU: calculate IVHD size with a function
      AMD IOMMU: use cmd_buf_size when freeing the command buffer
      add AMD IOMMU tree to MAINTAINERS file
      AMD IOMMU: use coherent_dma_mask in alloc_coherent

 Documentation/kernel-parameters.txt       |    4 +
 Documentation/x86/x86_64/boot-options.txt |    2 -
 MAINTAINERS                               |    1 +
 arch/x86/Kconfig                          |    1 +
 arch/x86/kernel/amd_iommu.c               |  318 ++++++++++++++++++++++++-----
 arch/x86/kernel/amd_iommu_init.c          |  191 ++++++++++++++++--
 arch/x86/kernel/pci-dma.c                 |   13 ++
 arch/x86/kernel/pci-gart_64.c             |   13 --
 include/asm-x86/amd_iommu.h               |    3 +
 include/asm-x86/amd_iommu_types.h         |   58 +++++-
 include/asm-x86/iommu.h                   |    1 +
 11 files changed, 517 insertions(+), 88 deletions(-)

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

