Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYLDRec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYLDRec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYLDR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:35 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:21246 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbYLDR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:23 -0500
X-BigFish: VPS5(z1039oz4015Mzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBD4K5-03-CR8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCH 0/11] Factor VT-d KVM functions into a generic API
Date: Thu, 4 Dec 2008 18:28:45 +0100
Message-ID: <1228411736-22644-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0553 (UTC) FILETIME=[C9321D90:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series makes the current KVM device passthrough code generic
enough so that other IOMMU implementation can also plug into this code.
It works by factoring the functions Vt-d code exports to KVM into a
generic interface which allows different backends.

This is the third version of the patchset. I rebased these patches onto
the 13-patches post of Han Weidongs multiple device assignment work and
included changes to the commit-messages according the comments I got
from the review.

This a basic implementation of a generic interface. It can and should be
improved later to support more types of hardware IOMMUs then VT-d and
AMD IOMMU.

Since I have no VT-d hardware available these patches are only compile
tested for now.

Please review, comment and test these patches.

Thanks,

Joerg

diffstat:

 arch/ia64/Kconfig                |    3 +
 arch/ia64/include/asm/kvm_host.h |    2 +-
 arch/ia64/kvm/Makefile           |    4 +-
 arch/ia64/kvm/kvm-ia64.c         |    3 +-
 arch/x86/Kconfig                 |    3 +
 arch/x86/include/asm/kvm_host.h  |    2 +-
 arch/x86/kvm/Makefile            |    4 +-
 arch/x86/kvm/x86.c               |    3 +-
 drivers/base/Makefile            |    1 +
 drivers/base/iommu.c             |  100 +++++++++++++++++++++++++++++++
 drivers/pci/intel-iommu.c        |  121 ++++++++++++++++++++++---------------
 include/linux/intel-iommu.h      |   21 -------
 include/linux/iommu.h            |  112 +++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h         |    6 +-
 virt/kvm/{vtd.c => iommu.c}      |   45 +++++++--------
 virt/kvm/kvm_main.c              |    2 +-
 16 files changed, 326 insertions(+), 106 deletions(-)



