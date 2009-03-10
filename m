Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZCJFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZCJFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZCJFLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:51849 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZCJFLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZXuPd57+0a5erd7xycLLPBSNaFANVSdKZulYSZiEJZpTJ8ymhZ/OjPMG19DI0dpJxk
         oy8NM1gocWbWjaWtrPzYkoBiWLluL5gD5BQsUH4JWjYer6xHmteTSZhcDSdCd6RSww2+
         tn0jpgdIeGKPrJnlmDn9oTqG8zhwZsX2Vc/oU=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 14/25] [mm] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:39 -0500
Message-Id: <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 mm/nommu.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 2fcf47d..22ddd6b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -486,21 +486,16 @@ static noinline void validate_nommu_regions(void)
 		return;
 
 	last = rb_entry(lastp, struct vm_region, vm_rb);
-	if (unlikely(last->vm_end <= last->vm_start))
-		BUG();
-	if (unlikely(last->vm_top < last->vm_end))
-		BUG();
+	BUG_ON(last->vm_end <= last->vm_start);
+	BUG_ON(last->vm_top < last->vm_end);
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
 		last = rb_entry(lastp, struct vm_region, vm_rb);
 
-		if (unlikely(region->vm_end <= region->vm_start))
-			BUG();
-		if (unlikely(region->vm_top < region->vm_end))
-			BUG();
-		if (unlikely(region->vm_start < last->vm_top))
-			BUG();
+		BUG_ON(region->vm_end <= region->vm_start);
+		BUG_ON(region->vm_top < region->vm_end);
+		BUG_ON(region->vm_start < last->vm_top);
 
 		lastp = p;
 	}
-- 
1.6.1.3

