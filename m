Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZGAOX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZGAOX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZGAOXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:23:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:56289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZGAOXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:23:50 -0400
Subject: [PATCH -tip] x86: amd_iommu.c device_nb should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 19:53:14 +0530
Message-Id: <1246458194.6940.20.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This sparse warning:

  arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?

triggers because device_nb is global but is only used in a single .c file.
change device_nb to static to fix that - this also address the sparse warning.

This sparse warning:

  arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer

triggers because plain integer 0 is used inplace of NULL pointer.
change 0 to NULL to fix that - this also address the sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9372f04..6c99f50 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1192,7 +1192,7 @@ out:
 	return 0;
 }
 
-struct notifier_block device_nb = {
+static struct notifier_block device_nb = {
 	.notifier_call = device_change_notifier,
 };
 
@@ -1763,7 +1763,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
-		return 0;
+		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 
-- 
1.6.0.6



