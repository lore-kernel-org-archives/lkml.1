Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbZDCKiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbZDCKiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763774AbZDCKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:37:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763603AbZDCKhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:37:17 -0400
Date: Fri, 3 Apr 2009 10:36:34 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, rcu: don't include unnecessary headers, allow kmemtrace w/ tracepoints
Message-ID: <tip-ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b@git.kernel.org>
Git-Commit-ID: ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b
Gitweb:     http://git.kernel.org/tip/ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:05 +0200

kmemtrace, rcu: don't include unnecessary headers, allow kmemtrace w/ tracepoints

Impact: cleanup

linux/percpu.h includes linux/slab.h, which generates circular inclusion
dependencies when trying to switch kmemtrace to use tracepoints instead
of markers.

This patch allows tracing within slab headers' inline functions.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcuclassic.h |    1 -
 include/linux/rcupdate.h   |    1 -
 include/linux/rcupreempt.h |    2 +-
 include/linux/rcutree.h    |    1 -
 4 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 2d688b4..bfd92e1 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -36,7 +36,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 528343e..15fbb3c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -36,7 +36,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 3eb8fdd..fce5227 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -36,7 +36,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
+#include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 5d6f425..0cdda00 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -33,7 +33,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
