Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZKDGpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZKDGpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZKDGpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:45:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:54142 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZKDGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=aV3H2cQhlxAZPnVJ7jM+Jvvu5GVGKzYtVDUQfaMhpGV3hWlLbMyd5kr+nMhlNS9tDV
         fCcOmMdV73pg4APcidltz2x0FErj9JV+XcuHhxr9lszOmTLJNUqEcOCTy7GhuREU/WpC
         tmt8lDiXa5fZhY00bYNL2TQS5mEnV9T7VrPe4=
Subject: [PATCH] mm/ksm.c - Fix compile warnings (PS ignore my formatting
 in previous email)
From: askb <askb23@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 12:13:30 +0530
Message-Id: <1257317010.14838.55.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found the compiler warning on linux-next: 	

mm/ksm.c: In function ‘ksm_scan_thread’:
mm/ksm.c:1083: warning: ‘page2[0u]’ may be used uninitialized in this
function
mm/ksm.c:1083: note: ‘page2[0u]’ was declared here

fix for the above warning:

Signed-off-by: Anil SB <askb23@gmail.com>

diff --git a/mm/ksm.c b/mm/ksm.c
index bef1af4..2ea0fd3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1080,7 +1080,7 @@ static void stable_tree_append(struct rmap_item *rmap_item,
  */
 static void cmp_and_merge_page(struct page *page, struct rmap_item *rmap_item)
 {
-	struct page *page2[1];
+	struct page *page2[1] = {NULL};
 	struct rmap_item *tree_rmap_item;
 	unsigned int checksum;
 	int err;




