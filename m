Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbYL3HmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbYL3HmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYL3Hli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:41:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:60268 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYL3Hlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=g+u0qekKrF1EMaBazhdyjkK/wm9FxuD71E3lM/nYueLqG5QXVj5d6UdRsmJdnvp2Ms
         0UAXtnMoMjRAdt1gMiBY3zIHRUa+SjhAmTb2gh4F/pbmRNVegU6KYCRDTQ1V0cJUKZC7
         qHCppVmpTWleDVrbiEeY9bFODW3PnEnXJG6Ro=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] RCU: Don't include unnecessary headers, allow kmemtrace w/ tracepoints.
Date: Tue, 30 Dec 2008 09:41:27 +0200
Message-Id: <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1230622068.git.eduard.munteanu@linux360.ro>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1230622068.git.eduard.munteanu@linux360.ro>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/percpu.h includes linux/slab.h, which generates circular inclusion
dependencies when trying to switch kmemtrace to use tracepoints instead
of markers. This patch allows tracing within slab headers' inline
functions.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/rcuclassic.h |    1 -
 include/linux/rcupdate.h   |    1 -
 include/linux/rcupreempt.h |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..b33004a 100644
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
index 86f1f5e..8f1c892 100644
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
index 3e05c09..3429415 100644
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
 
-- 
1.6.0.6

