Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZCWPTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZCWPTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZCWPT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:19:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:48127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbZCWPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:19:27 -0400
Date: Mon, 23 Mar 2009 15:18:29 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
References: <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] rcu: don't include unnecessary headers, allow kmemtrace w/ tracepoints
Message-ID: <tip-e251ea2fa52321009940fad02238ef1c369531ae@git.kernel.org>
Git-Commit-ID: e251ea2fa52321009940fad02238ef1c369531ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:18:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e251ea2fa52321009940fad02238ef1c369531ae
Gitweb:     http://git.kernel.org/tip/e251ea2fa52321009940fad02238ef1c369531ae
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:06:54 +0100

rcu: don't include unnecessary headers, allow kmemtrace w/ tracepoints

linux/percpu.h includes linux/slab.h, which generates circular inclusion
dependencies when trying to switch kmemtrace to use tracepoints instead
of markers. This patch allows tracing within slab headers' inline
functions.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: rostedt@goodmis.org
Cc: compudj@krystal.dyndns.org
Cc: fweisbec@gmail.com
Cc: penberg@cs.helsinki.fi
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcuclassic.h |    1 -
 include/linux/rcupdate.h   |    1 -
 include/linux/rcupreempt.h |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 80044a4..cc3f723 100644
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
index 74304b4..5ff2d23 100644
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
 
