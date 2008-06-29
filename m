Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYF2XNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYF2XNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYF2XMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:12:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:32995 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYF2XMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:12:36 -0400
Date: Mon, 30 Jun 2008 08:11:22 +0900
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Cc: joerg.roedel@amd.com
Subject: [PATCH] x86 gart: remove unnecessary set_bit_string
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080630081117R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to remove unnecessary set_bit_string when I converted the
gart driver to use the IOMMU helper.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86 gart: remove unnecessary set_bit_string

iommu_area_alloc internally calls set_bit_string and set bits
properly. This set_bit_string is unnecessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index aa8ec92..6183e8c 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -104,7 +104,6 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 					  size, base_index, boundary_size, 0);
 	}
 	if (offset != -1) {
-		set_bit_string(iommu_gart_bitmap, offset, size);
 		next_bit = offset+size;
 		if (next_bit >= iommu_pages) {
 			next_bit = 0;
-- 
1.5.5.GIT

