Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbZCaWxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbZCaWxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763780AbZCaWwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:22 -0400
Received: from gw.goop.org ([64.81.55.164]:53465 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756878AbZCaWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb updates for Xen dom0
Date: Tue, 31 Mar 2009 15:52:06 -0700
Message-Id: <1238539935-4295-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Fujita,

This series adds Xen support to x86 swiotlb.  This is mostly a matter of
adding some Xen code into the existing hooks in pci-swiotlb_64.c:
  - swiotlb_alloc_boot
  - swiotlb_arch_range_needs_mapping
  - swiotlb_phys_to_bus/bus_to_phys

These hooks are conditional on xen_pv_domain(), which compiles to a
constant 0 when CONFIG_XEN is not enabled (and is a simple variable
read when it is).

All the Xen-specific code is in xen-iommu.c.

This series is just the patches which touch lib/swiotlb.c or
pci-swiotlb_64.c.  You can see them with more context in:
   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-linus/xen/dom0/swiotlb

Thanks,
	J

 arch/x86/kernel/pci-swiotlb_64.c |   31 ++++++++++++++++-
 arch/x86/xen/Kconfig             |    1 
 drivers/pci/xen-iommu.c          |   68 ++++++++++++++++++++++++++++++++++++---
 include/xen/swiotlb.h            |   38 +++++++++++++++++++++
 lib/swiotlb.c                    |    3 +
 5 files changed, 133 insertions(+), 8 deletions(-)


