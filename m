Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYLBNGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYLBNGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYLBNCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:19 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28609 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYLBNCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:02:16 -0500
X-BigFish: VPS5(z1039oz4015Mzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB92UA-04-VCL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: [PATCH 0/12] Factor VT-d KVM functions into a generic API (with multiple device assignment support)
Date: Tue, 2 Dec 2008 14:01:11 +0100
Message-ID: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0769 (UTC) FILETIME=[142A2A90:01C9547E]
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

This is the second version of the patchset. The most important change to
the previous version is that this patchset was rebased to the improved
API from Han Weidong which supports multiple devices per IOMMU domain.

For completeness, this series also includes the patches from Han with
some cleanups. So this patchset can be applied on current avi/master
tree.

For testing this code can also be pulled against avi/master tree from

git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-api

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
 arch/ia64/kvm/Makefile          |    4 +-
 arch/x86/Kconfig                |    3 +
 arch/x86/include/asm/kvm_host.h |    3 +-
 arch/x86/kvm/Makefile           |    4 +-
 drivers/base/Makefile           |    1 +
 drivers/base/iommu.c            |  100 ++++++
 drivers/pci/dmar.c              |   15 +-
 drivers/pci/intel-iommu.c       |  738 +++++++++++++++++++++++++++++++++------
 include/linux/dma_remapping.h   |   21 +-
 include/linux/dmar.h            |    2 +
 include/linux/intel-iommu.h     |   13 +-
 include/linux/iommu.h           |  109 ++++++
 include/linux/kvm.h             |    5 +
 include/linux/kvm_host.h        |   23 +-
 virt/kvm/{vtd.c => iommu.c}     |  131 +++++---
 virt/kvm/kvm_main.c             |   49 +++-




