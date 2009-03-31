Return-Path: <linux-kernel-owner+w=401wt.eu-S1764159AbZCaWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764159AbZCaWzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763812AbZCaWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53484 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763128AbZCaWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 9/9] pci-swiotlb: remove __weak vs __weak binding
Date: Tue, 31 Mar 2009 15:52:15 -0700
Message-Id: <1238539935-4295-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

swiotlb_arch_range_needs_mapping() is weak in lib/swiotlb.c so that
architectures can override it.  The override versions shouldn't be
weak too.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 3b9f817..7894315 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -52,7 +52,7 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 	return baddr;
 }
 
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
+int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	if (xen_pv_domain())
 		return xen_range_needs_mapping(paddr, size);
-- 
1.6.0.6

