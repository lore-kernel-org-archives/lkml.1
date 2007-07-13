Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXGMKVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXGMKVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXGMKV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:21:28 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:39329 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbXGMKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:21:22 -0400
Date: Fri, 13 Jul 2007 14:21:12 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix sparse false positives re BUG_ON(ptr)
Message-ID: <20070713102111.GA11046@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sparse now warns if one compares pointers with integers. However, there are
false positives, like:

	fs/filesystems.c:72:2: warning: Using plain integer as NULL pointer

Every time BUG_ON(ptr) is used, ptr is checked against integer zero. Avoid that
and save ~70 false positives from allyesconfig run.

mentioned by Al.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -28,7 +28,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely((condition)!=0)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON

