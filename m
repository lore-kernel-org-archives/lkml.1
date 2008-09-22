Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYIVSVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYIVSVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYIVSV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:29 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:30598 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYIVSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:28 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7M0BF-04-6EX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/9][RFC] stackable dma_ops for x86
Date: Mon, 22 Sep 2008 20:21:12 +0200
Message-ID: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0227 (UTC) FILETIME=[036989B0:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series implements stackable dma_ops on x86. This is useful to
be able to fall back to a different dma_ops implementation if one can
not handle a particular device (as necessary for example with
paravirtualized device passthrough or if a hardware IOMMU only handles a
subset of available devices).
The patch series is split to change the different iommu implementations
in different patches. This should make it easier for the specific
maintainers to review the part that changes their code.


Thanks for review and comments,

Joerg

diffstat:

 arch/x86/kernel/amd_iommu.c      |    5 ++-
 arch/x86/kernel/pci-calgary_64.c |   21 ++++++------
 arch/x86/kernel/pci-dma.c        |   63 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/pci-gart_64.c    |    9 +++++
 arch/x86/kernel/pci-nommu.c      |   12 +++++++
 arch/x86/kernel/pci-swiotlb_64.c |   16 +++++++++-
 drivers/pci/intel-iommu.c        |    8 +++++
 include/asm-x86/device.h         |    6 ++--
 include/asm-x86/dma-mapping.h    |   43 +++++++++++++++++++++----
 include/asm-x86/swiotlb.h        |    1 +
 10 files changed, 160 insertions(+), 24 deletions(-)



