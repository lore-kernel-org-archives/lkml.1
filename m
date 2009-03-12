Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZCLWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZCLWLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZCLWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:11:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47238 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZCLWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:11:23 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] futex: remove the pointer math from double_unlock_hb
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 15:11:18 -0700
Message-ID: <20090312221118.11146.68610.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mistakenly included the pointer value ordering in the double_unlock_hb
in my previous patch.  It's only necessary in the double_lock_hb
function.  This patch removes it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

