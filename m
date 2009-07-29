Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZG2Qz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZG2Qz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZG2Qz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:55:57 -0400
Received: from nox.protox.org ([88.191.38.29]:41587 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbZG2Qz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:55:56 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Fix caching mode selection for GTT object
Date: Wed, 29 Jul 2009 18:55:53 +0200
Message-Id: <1248886553-10164-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GTT object can either be cached,uncached or wc just let core ttm
pick the best mode according to how the bo driver and GTT memory
type was initialized.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_object.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index dd9ac2f..e98cae3 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -106,7 +106,7 @@ static inline uint32_t radeon_object_flags_from_domain(uint32_t domain)
 		flags |= TTM_PL_FLAG_VRAM | TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
 	}
 	if (domain & RADEON_GEM_DOMAIN_GTT) {
-		flags |= TTM_PL_FLAG_TT | TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
+		flags |= TTM_PL_FLAG_TT | TTM_PL_MASK_CACHING;
 	}
 	if (domain & RADEON_GEM_DOMAIN_CPU) {
 		flags |= TTM_PL_FLAG_SYSTEM | TTM_PL_MASK_CACHING;
-- 
1.6.2.5

