Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZGaIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZGaIrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZGaIrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:47:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:57071 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbZGaIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:47:48 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH] ttm: Fix a potential comparison of structs.
Date: Fri, 31 Jul 2009 10:47:51 +0200
Message-Id: <1249030071-17763-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures the comparison may cause a compilation failure.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index ce2e6f3..ee9a281 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -150,7 +150,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 #ifdef CONFIG_X86
 	dst = kmap_atomic_prot(d, KM_USER0, prot);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		dst = vmap(&d, 1, 0, prot);
 	else
 		dst = kmap(d);
@@ -163,7 +163,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 #ifdef CONFIG_X86
 	kunmap_atomic(dst, KM_USER0);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		vunmap(dst);
 	else
 		kunmap(d);
-- 
1.6.1.3

