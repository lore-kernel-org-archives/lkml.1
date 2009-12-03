Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZLCNYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZLCNYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZLCNYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:24:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:32925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbZLCNYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:24:04 -0500
Date: Thu, 3 Dec 2009 13:23:25 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1259783357-8542-2-git-send-regression-fweisbec@gmail.com>
References: <1259783357-8542-2-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Fix missing conditions to build mutex_spin_on_owner()
Message-ID: <tip-c08f782985eed9959438368e84ce1d7f2ed03d95@git.kernel.org>
Git-Commit-ID: c08f782985eed9959438368e84ce1d7f2ed03d95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c08f782985eed9959438368e84ce1d7f2ed03d95
Gitweb:     http://git.kernel.org/tip/c08f782985eed9959438368e84ce1d7f2ed03d95
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 2 Dec 2009 20:49:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:50:11 +0100

mutex: Fix missing conditions to build mutex_spin_on_owner()

We don't need to build mutex_spin_on_owner() if we have
CONFIG_DEBUG_MUTEXES or CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES as
it won't be used under such configs.

Use CONFIG_MUTEX_SPIN_ON_OWNER as it gathers all the necessary
checks before building it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1259783357-8542-2-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..ec0af1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5481,7 +5481,7 @@ need_resched_nonpreemptible:
 }
 EXPORT_SYMBOL(schedule);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 /*
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
