Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXLFQOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXLFQOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXLFQOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:14:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:16805 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbXLFQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rT0bpSNi25DYwuOpfmPCoqnjJhMKkpJDe6Rc3u7OOI4hVpWyH4BKcMeNq6HoIVAn6xVNGRGno5kbXkKMvwLNLdxBKvzJgXl3pDbO2XnrvXmt6FxHvlT+B3RdcCSI5+1zhke6VRS3WSfa67e4LpPJ/5gQEOa2fovN8ZydWMEqPgA=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] net/iucv/iucv.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:13:25 +0800
Message-Id: <1196957605-5797-3-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1196957605-5797-2-git-send-email-crquan@gmail.com>
References: <
 <1196957605-5797-1-git-send-email-crquan@gmail.com>
 <1196957605-5797-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these three list_head are all local variables, but can also use LIST_HEAD.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/iucv/iucv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 7698f6c..f13fe88 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1492,7 +1492,7 @@ static void iucv_tasklet_fn(unsigned long ignored)
 		[0x08] = iucv_message_pending,
 		[0x09] = iucv_message_pending,
 	};
-	struct list_head task_queue = LIST_HEAD_INIT(task_queue);
+	LIST_HEAD(task_queue);
 	struct iucv_irq_list *p, *n;
 
 	/* Serialize tasklet, iucv_path_sever and iucv_path_connect. */
@@ -1526,7 +1526,7 @@ static void iucv_tasklet_fn(unsigned long ignored)
 static void iucv_work_fn(struct work_struct *work)
 {
 	typedef void iucv_irq_fn(struct iucv_irq_data *);
-	struct list_head work_queue = LIST_HEAD_INIT(work_queue);
+	LIST_HEAD(work_queue);
 	struct iucv_irq_list *p, *n;
 
 	/* Serialize tasklet, iucv_path_sever and iucv_path_connect. */
-- 
1.5.3.4

