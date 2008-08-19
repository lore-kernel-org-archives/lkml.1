Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHSOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHSOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYHSOdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:08 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41818 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYHSOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:06 -0400
X-BigFish: VPS3(zz10d1Izz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2J-04-SOT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Date: Tue, 19 Aug 2008 16:32:38 +0200
Message-ID: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0500 (UTC) FILETIME=[72C0C640:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset reworks the dma_*_coherent functions in the DMA layer for the x86
architecture. The patch series extends the existing DMA backends with missing
*coherent callbacks and simplifies the generic function to basically only call
the registered backend. This allows future optimizations in hardware specific
IOMMU implementations.
The code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as well as
on my old 486 box. Muli tested the Calgary specific patch.

Joerg

Changes since v1:

- fixed wrong logic in the pci-nommu alloc_coherent code
- moved dma_*_coherent to include/asm-x86/dma-mapping.h

git diff --stat tip/master.. :

 arch/x86/kernel/amd_iommu.c      |    2 -
 arch/x86/kernel/pci-calgary_64.c |   14 ++++
 arch/x86/kernel/pci-dma.c        |  146 +-------------------------------------
 arch/x86/kernel/pci-gart_64.c    |   35 +++++++++-
 arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
 include/asm-x86/dma-mapping.h    |   47 ++++++++++---
 6 files changed, 149 insertions(+), 157 deletions(-)



