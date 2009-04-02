Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZDBAng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZDBAng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZDBAnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:43:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZDBAnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:43:03 -0400
Date: Thu, 2 Apr 2009 00:42:29 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, eparis@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eparis@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-3a2d367d9aabac486ac4444c6c7ec7a1dab16267@git.kernel.org>
References: <tip-3a2d367d9aabac486ac4444c6c7ec7a1dab16267@git.kernel.org>
Subject: [tip:perfcounters/core] mutex: drop "inline" from mutex_lock() inside kernel/mutex.c
Message-ID: <tip-655be4a209fbcae85a745027f426e1f9879b5648@git.kernel.org>
Git-Commit-ID: 655be4a209fbcae85a745027f426e1f9879b5648
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 00:42:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  655be4a209fbcae85a745027f426e1f9879b5648
Gitweb:     http://git.kernel.org/tip/655be4a209fbcae85a745027f426e1f9879b5648
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 17:21:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 1 Apr 2009 17:21:56 -0700

mutex: drop "inline" from mutex_lock() inside kernel/mutex.c

Impact: build fix

mutex_lock() is was defined inline in kernel/mutex.c, but wasn't
declared so not in <linux/mutex.h>.  This didn't cause a problem until
checkin 3a2d367d9aabac486ac4444c6c7ec7a1dab16267 added the
atomic_dec_and_mutex_lock() inline in between declaration and
definion.

This broke building with CONFIG_ALLOW_WARNINGS=n, e.g. make
allnoconfig.

Either from the source code nor the allnoconfig binary output I cannot
find any internal references to mutex_lock() in kernel/mutex.c, so
presumably this "inline" is now-useless legacy.

Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <tip-3a2d367d9aabac486ac4444c6c7ec7a1dab16267@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


---
 kernel/mutex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index e1fb735..29758eb 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -89,7 +89,7 @@ __mutex_lock_slowpath(atomic_t *lock_count);
  *
  * This function is similar to (but not equivalent to) down().
  */
-void inline __sched mutex_lock(struct mutex *lock)
+void __sched mutex_lock(struct mutex *lock)
 {
 	might_sleep();
 	/*
