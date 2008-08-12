Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYHLPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYHLPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYHLPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:12 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:47821 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYHLPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:11 -0400
X-BigFish: VPS3(zz10d1Izz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K5HUTF-04-OHZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: [PATCH 0/7] x86 dma_*_coherent rework patchset
Date: Tue, 12 Aug 2008 17:24:10 +0200
Message-ID: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0048 (UTC) FILETIME=[7C915000:01C8FC8F]
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
The code ist tested on AMD64 with AMD IOMMU and GART as well as on my old 486
box. It is not yet tested on a Calgary IOMMU system.

Joerg

git diff --stat tip/master:

 arch/x86/kernel/amd_iommu.c      |    2 -
 arch/x86/kernel/pci-calgary_64.c |   14 +++++
 arch/x86/kernel/pci-dma.c        |  116 +++----------------------------------
 arch/x86/kernel/pci-gart_64.c    |   31 ++++++++++
 arch/x86/kernel/pci-nommu.c      |   45 +++++++++++++++
 5 files changed, 100 insertions(+), 108 deletions(-)




