Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbYF0VkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbYF0VkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764154AbYF0Vh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764209AbYF0VhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:16 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 06/39] use something common for both architectures
Date: Fri, 27 Jun 2008 18:34:13 -0300
Message-Id: <1214602486-17080-7-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-6-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using explicit hexa (0xFFFFFFUL) introduces an unnecessary difference
between i386 and x86_64 because of the size of their long. Use -1UL instead.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_32.h |    2 +-
 include/asm-x86/uaccess_64.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 8e7595c..6a8adec 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -25,7 +25,7 @@
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
 
-#define KERNEL_DS	MAKE_MM_SEG(0xFFFFFFFFUL)
+#define KERNEL_DS	MAKE_MM_SEG(-1UL)
 #define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
 
 #define get_ds()	(KERNEL_DS)
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index b8a2f43..83382c1 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -22,7 +22,7 @@
 
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
-#define KERNEL_DS	MAKE_MM_SEG(0xFFFFFFFFFFFFFFFFUL)
+#define KERNEL_DS	MAKE_MM_SEG(-1UL)
 #define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
 
 #define get_ds()	(KERNEL_DS)
-- 
1.5.5.1

