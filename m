Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYK0Png@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYK0Png (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYK0Pl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:29 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54029 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYK0PlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:18 -0500
X-BigFish: VPS5(z1039oz4015Mzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB00W5-03-L77-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com
Subject: [PATCH 0/9] Factor VT-d KVM functions into a generic API
Date: Thu, 27 Nov 2008 16:40:45 +0100
Message-ID: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0774 (UTC) FILETIME=[88DCE160:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series makes the current KVM device passthrough code generic
enough so that other IOMMU implementation can also plug into this code.
It works by factoring the functions Vt-d code exports to KVM into a
generic interface which allows different backends.

This a basic implementation of a generic interface. It can and should be
improved later to support more types of hardware IOMMUs then VT-d and
AMD IOMMU.

Since I have no VT-d hardware available these patches are only compile
tested for now.

Please review, comment and test these patches.

Thanks,

Joerg

diffstat:

 arch/ia64/Kconfig               |    3 +
 arch/ia64/kvm/Makefile          |    2 +-
 arch/x86/Kconfig                |    3 +
 arch/x86/include/asm/kvm_host.h |    3 +-
 arch/x86/kvm/Makefile           |    2 +-
 drivers/base/Makefile           |    1 +
 drivers/base/iommu.c            |   94 +++++++++++++++++++
 drivers/pci/intel-iommu.c       |   91 ++++++++++++++++++
 include/linux/iommu.h           |  100 ++++++++++++++++++++
 virt/kvm/iommu.c                |  193 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/vtd.c                  |  191 --------------------------------------



