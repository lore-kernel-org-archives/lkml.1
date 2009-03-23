Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZCWNMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZCWNMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZCWNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:50642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZCWNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YY5ebJG4hP+YfVJhPiR/3fhdkXinSO3ghW4lPyc3e+YBKJ8Kvf0zdwXEzH6SlTTP9H
         XeWkgx+Ws02810QsXh0nmbzMI4k3QujVpJUEnnlkRi5SZxARQ0mBzCkGwwN5Kk9s7LaC
         G7gSJk+xlphSOY6FYE1AaTQ+XPiYOVAHdDV/4=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] RCU: don't include unnecessary headers, allow kmemtrace w/ tracepoints
Date: Mon, 23 Mar 2009 15:12:21 +0200
Message-Id: <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
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
index f3f697d..4677c94 100644
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
index 921340a..671546a 100644
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

