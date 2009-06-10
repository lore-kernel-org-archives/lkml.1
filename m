Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZFJJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZFJJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbZFJJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:52:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbZFJJwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:52:08 -0400
Date: Wed, 10 Jun 2009 09:51:32 GMT
From: tip-bot for Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       benh@kernel.crashing.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/locking] spinlock: Add missing __raw_spin_lock_flags() stub for UP
Message-ID: <tip-04dce7d9d429ea5ea04e9432d1726c930f4d67da@git.kernel.org>
Git-Commit-ID: 04dce7d9d429ea5ea04e9432d1726c930f4d67da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 09:51:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04dce7d9d429ea5ea04e9432d1726c930f4d67da
Gitweb:     http://git.kernel.org/tip/04dce7d9d429ea5ea04e9432d1726c930f4d67da
Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
AuthorDate: Wed, 10 Jun 2009 16:59:46 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 11:48:14 +0200

spinlock: Add missing __raw_spin_lock_flags() stub for UP

This was only defined with CONFIG_DEBUG_SPINLOCK set, but some
obscure arch/powerpc code wants it always.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/spinlock_up.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index 938234c..d4841ed 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -60,6 +60,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 #define __raw_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched.c and kernel_lock.c: */
 # define __raw_spin_lock(lock)		do { (void)(lock); } while (0)
+# define __raw_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
 # define __raw_spin_unlock(lock)	do { (void)(lock); } while (0)
 # define __raw_spin_trylock(lock)	({ (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
