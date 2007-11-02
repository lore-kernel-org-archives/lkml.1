Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXKBPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXKBPrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbXKBPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:45:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53871 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759805AbXKBPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:45:11 -0400
Date: Fri, 2 Nov 2007 16:44:49 +0100
From: Adrian Bunk <bunk@kernel.org>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/power/: move function prototypes to header
Message-ID: <20071102154449.GR30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the prototypes of count_highmem_pages() and 
restore_highmem() to kernel/power/power.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/power/power.h    |    8 ++++++++
 kernel/power/snapshot.c |    1 -
 kernel/power/swsusp.c   |    8 --------
 3 files changed, 8 insertions(+), 9 deletions(-)

20af06052a0203d9e60b4937282793900c756182 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 195dc46..3fe1e7f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -211,3 +211,11 @@ static inline int pm_notifier_call_chain(unsigned long val)
 	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
 			== NOTIFY_BAD) ? -EINVAL : 0;
 }
+
+#ifdef CONFIG_HIGHMEM
+unsigned int count_highmem_pages(void);
+int restore_highmem(void);
+#else
+static inline unsigned int count_highmem_pages(void) { return 0; }
+static inline int restore_highmem(void) { return 0; }
+#endif
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 78039b4..d9ed1ff 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -872,7 +872,6 @@ unsigned int count_highmem_pages(void)
 }
 #else
 static inline void *saveable_highmem_page(unsigned long pfn) { return NULL; }
-static inline unsigned int count_highmem_pages(void) { return 0; }
 #endif /* CONFIG_HIGHMEM */
 
 /**
diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
index e1722d3..605c536 100644
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -64,14 +64,6 @@ unsigned long image_size = 500 * 1024 * 1024;
 
 int in_suspend __nosavedata = 0;
 
-#ifdef CONFIG_HIGHMEM
-unsigned int count_highmem_pages(void);
-int restore_highmem(void);
-#else
-static inline int restore_highmem(void) { return 0; }
-static inline unsigned int count_highmem_pages(void) { return 0; }
-#endif
-
 /**
  *	The following functions are used for tracing the allocated
  *	swap pages, so that they can be freed in case of an error.

