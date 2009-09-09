Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZIIU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZIIU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZIIU32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:29:28 -0400
Received: from nox.protox.org ([88.191.38.29]:52613 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZIIU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:29:27 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Don't try to process irq when we are unloading
Date: Wed,  9 Sep 2009 22:23:07 +0200
Message-Id: <1252527787-2203-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If module is being unloaded we should not try to handle irq especialy
we should not call into drm helper or we could hard hang the computer
free_irq will call the irq handler to make sure we behave properly.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 5708c07..36d0ba2 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -319,6 +319,9 @@ int r100_irq_process(struct radeon_device *rdev)
 	if (!status) {
 		return IRQ_NONE;
 	}
+	if (rdev->shutdown) {
+		return IRQ_NONE;
+	}
 	while (status) {
 		/* SW interrupt */
 		if (status & RADEON_SW_INT_TEST) {
-- 
1.6.4.1

