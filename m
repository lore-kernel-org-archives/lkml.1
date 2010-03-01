Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0CAT7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:59:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:37695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab0CAT7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:59:01 -0500
Date: Mon, 1 Mar 2010 19:58:37 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, luca@luca-barbieri.com,
       tglx@linutronix.de
In-Reply-To: <1267469749-11878-4-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-4-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] lib: Fix atomic64_add_unless return value convention
Message-ID: <tip-97577896f6b9c056fa0a5e9f6a608110cb3dcd33@git.kernel.org>
Git-Commit-ID: 97577896f6b9c056fa0a5e9f6a608110cb3dcd33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:58:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97577896f6b9c056fa0a5e9f6a608110cb3dcd33
Gitweb:     http://git.kernel.org/tip/97577896f6b9c056fa0a5e9f6a608110cb3dcd33
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Mon, 1 Mar 2010 19:55:47 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:38:46 -0800

lib: Fix atomic64_add_unless return value convention

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The generic implementation did the opposite thing.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Confirmed-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267469749-11878-4-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
