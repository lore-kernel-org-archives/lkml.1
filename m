Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbZFRK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbZFRK44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZFRK4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:56:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbZFRK4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:56:48 -0400
Subject: [PATCH -tip] x86: amd_iommu.c device_nb should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 16:26:13 +0530
Message-Id: <1245322573.7189.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


device_nb is used only by same file, it should be static.

Also fixed NULL pointer issue.

Fixed following sparse warnings :
  arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?
  arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer

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



