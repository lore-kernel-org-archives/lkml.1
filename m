Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZFBUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZFBUQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZFBUQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:59430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZFBUQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:16:21 -0400
Date: Tue, 2 Jun 2009 20:15:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] x86: Fix atomic_long_xchg() on 64bit
Message-ID: <tip-53e111a730ea8b002d57dd226098c12789993329@git.kernel.org>
Git-Commit-ID: 53e111a730ea8b002d57dd226098c12789993329
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:15:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53e111a730ea8b002d57dd226098c12789993329
Gitweb:     http://git.kernel.org/tip/53e111a730ea8b002d57dd226098c12789993329
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 17:01:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:29 +0200

x86: Fix atomic_long_xchg() on 64bit

Apparently I'm the first to use it :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/asm-generic/atomic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 3673a13..81d3be4 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -134,7 +134,7 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
 #define atomic_long_cmpxchg(l, old, new) \
 	(atomic64_cmpxchg((atomic64_t *)(l), (old), (new)))
 #define atomic_long_xchg(v, new) \
-	(atomic64_xchg((atomic64_t *)(l), (new)))
+	(atomic64_xchg((atomic64_t *)(v), (new)))
 
 #else  /*  BITS_PER_LONG == 64  */
 
