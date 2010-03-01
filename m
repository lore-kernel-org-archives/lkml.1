Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab0CAS4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:56:01 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41232 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0CASz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=J1sDYHk8mTsOv2rBabHbLJ45mlYBidvDKD2l4uX/0AEPe6+mMN0q2qkubdrRxlXPXL
         W9WPCMiZJUDLs2Ogd62SuBJyWreR+KOhxupk0psjzXtEFzxzHYhlnMvIh4f9l8DjRwhu
         ZI7tFKeUXOtOg6ZGHnmg7APq131KQsINQmGqg=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 3/5] lib: fix atomic64_add_unless return value convention
Date: Mon,  1 Mar 2010 19:55:47 +0100
Message-Id: <1267469749-11878-4-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The generic implementation did the opposite thing.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/atomic64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/atomic64.c b/lib/atomic64.c
index 8bee16e..a21c12b 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -162,12 +162,12 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned long flags;
 	spinlock_t *lock = lock_addr(v);
-	int ret = 1;
+	int ret = 0;
 
 	spin_lock_irqsave(lock, flags);
 	if (v->counter != u) {
 		v->counter += a;
-		ret = 0;
+		ret = 1;
 	}
 	spin_unlock_irqrestore(lock, flags);
 	return ret;
-- 
1.6.6.1.476.g01ddb

