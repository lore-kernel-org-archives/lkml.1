Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZI2XMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZI2XMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZI2XMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:12:53 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:46747 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZI2XMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:12:53 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
       Daniel Walker <dwalker@fifo99.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] WARN_ONCE(): use bool for boolean flag
Date: Tue, 29 Sep 2009 20:12:28 -0300
Message-Id: <1254265948-29729-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <4AC2943E.2070502@cesarb.net>
References: <4AC2943E.2070502@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 70867453092297be9afb2249e712a1f960ec0a09 changed printk_once()
to use bool instead of int for its guard variable. Do the same change
to WARN_ONCE() and WARN_ON_ONCE(), for the same reasons.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 include/asm-generic/bug.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 4b67559..18c435d 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -113,22 +113,22 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN_ON(!__warned)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN(!__warned, format)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
-- 
1.6.4.4

