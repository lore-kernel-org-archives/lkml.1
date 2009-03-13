Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZCMAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZCMAUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZCMAUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:20:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:55623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZCMAUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:20:01 -0400
Date: Fri, 13 Mar 2009 00:18:26 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312221118.11146.68610.stgit@Aeon>
References: <20090312221118.11146.68610.stgit@Aeon>
Subject: [tip:core/futexes] futex: remove the pointer math from double_unlock_hb
Message-ID: <tip-f061d35150003b7fd5b133d14d66a74500fdaa60@git.kernel.org>
Git-Commit-ID: f061d35150003b7fd5b133d14d66a74500fdaa60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 00:18:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f061d35150003b7fd5b133d14d66a74500fdaa60
Gitweb:     http://git.kernel.org/tip/f061d35150003b7fd5b133d14d66a74500fdaa60
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 15:11:18 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 01:15:46 +0100

futex: remove the pointer math from double_unlock_hb

Impact: simplify code

I mistakenly included the pointer value ordering in the
double_unlock_hb() in my previous patch. It's only necessary
in the double_lock_hb() function. This patch removes it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090312221118.11146.68610.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9c97f67..2331b73 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -658,14 +658,8 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 static inline void
 double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 {
-	if (hb1 <= hb2) {
-		spin_unlock(&hb2->lock);
-		if (hb1 < hb2)
-			spin_unlock(&hb1->lock);
-	} else { /* hb1 > hb2 */
-		spin_unlock(&hb1->lock);
-		spin_unlock(&hb2->lock);
-	}
+	spin_unlock(&hb1->lock);
+	spin_unlock(&hb2->lock);
 }
 
 /*
