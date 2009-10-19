Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZJSGs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZJSGs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZJSGs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:48:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:55464 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZJSGs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s/53Xugmm4IglwooDIv+rEc0r6VQve/Qt1dyKYAPjJxUuHwCh2YAWBAT+mzgZ8iXqC
         5UwaCkD7Lk8xBg4wMw8n1gHCdISbA8IWcy9RKnY8zm2as8qFzPPlyjsiiDFxtFL8pSaw
         1r75vlrrBm/g3SiAYVSX0wprNcvIzfYr18oxg=
From: Peng Tao <bergwolf@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] mm: fix comments for invalidate_inode_pages2()
Date: Mon, 19 Oct 2009 14:48:13 +0800
Message-Id: <1255934893-7696-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.6.2-rc2.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

invalidate_inode_pages2() returns -EBUSY *NOT* -EIO if any pages could not be
invalidated.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 mm/truncate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 450cebd..2c147a7 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -490,7 +490,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
  * Any pages which are found to be mapped into pagetables are unmapped prior to
  * invalidation.
  *
- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EBUSY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2(struct address_space *mapping)
 {
-- 
1.6.2-rc2.GIT

