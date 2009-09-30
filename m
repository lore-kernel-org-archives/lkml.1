Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZI3AiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZI3AiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZI3AiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:38:10 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:39753 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI3AiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:38:10 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
       Daniel Walker <dwalker@fifo99.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] WARN_ONCE(): use bool for boolean flag
Date: Tue, 29 Sep 2009 21:37:58 -0300
Message-Id: <1254271078-5065-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20090929171718.4bafa915.akpm@linux-foundation.org>
References: <20090929171718.4bafa915.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 70867453092297be9afb2249e712a1f960ec0a09 changed printk_once()
to use bool instead of int for its guard variable. Do the same change
to WARN_ONCE() and WARN_ON_ONCE(), for the same reasons.

This resulted in a reduction of 1462 bytes on a x86-64 defconfig:

   text    data     bss     dec     hex filename
8101271 1207116  992764 10301151         9d2edf vmlinux.before
8100553 1207148  991988 10299689         9d2929 vmlinux.after

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---

Andrew Morton escreveu:
> Again, it would be useful were this changelog to describe the impact
> upon kernel code size, please.

Is the above good enough?

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

