Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551Ab0A2J3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0A2J3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836Ab0A2J3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:29:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:57479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0A2J3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:29:49 -0500
Date: Fri, 29 Jan 2010 09:28:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.797688466@chello.nl>
References: <20100122155535.797688466@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] bitops: Provide compile time HWEIGHT{8,16,32,64}
Message-ID: <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
Git-Commit-ID: 9f41699ed067fa695faff8e2e9981b2550abec62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:28:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f41699ed067fa695faff8e2e9981b2550abec62
Gitweb:     http://git.kernel.org/tip/9f41699ed067fa695faff8e2e9981b2550abec62
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 15:59:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:39 +0100

bitops: Provide compile time HWEIGHT{8,16,32,64}

Provide compile time versions of hweight.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20100122155535.797688466@chello.nl>
[ Remove some whitespace damage while we are at it ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/bitops.h |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index c05a29c..ba0fd1e 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -25,7 +25,7 @@
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
-	
+
 	order = fls(count);
 	return order;	/* We could be slightly more clever with -1 here... */
 }
@@ -33,7 +33,7 @@ static __inline__ int get_bitmask_order(unsigned int count)
 static __inline__ int get_count_order(unsigned int count)
 {
 	int order;
-	
+
 	order = fls(count) - 1;
 	if (count & (count - 1))
 		order++;
@@ -45,6 +45,20 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
+#define HWEIGHT8(w)			\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
+#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
+#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
+
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
