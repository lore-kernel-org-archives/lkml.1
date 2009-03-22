Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZCVTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZCVTl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZCVTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:40:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:40847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbZCVTkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:40:33 -0400
Date: Sun, 22 Mar 2009 19:39:56 GMT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dmitri.vorobiev@movial.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dmitri.vorobiev@movial.com, mingo@elte.hu
In-Reply-To: <1237741871-5827-4-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-4-git-send-email-dmitri.vorobiev@movial.com>
Subject: [tip:tracing/ftrace] tracing: fix four sparse warnings
Message-ID: <tip-b8b94265337f83b7db9c5f429b1769d463d7da8c@git.kernel.org>
Git-Commit-ID: b8b94265337f83b7db9c5f429b1769d463d7da8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:39:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8b94265337f83b7db9c5f429b1769d463d7da8c
Gitweb:     http://git.kernel.org/tip/b8b94265337f83b7db9c5f429b1769d463d7da8c
Author:     Dmitri Vorobiev <dmitri.vorobiev@movial.com>
AuthorDate: Sun, 22 Mar 2009 19:11:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:16:54 +0100

tracing: fix four sparse warnings

Impact: cleanup.

This patch fixes the following sparse warnings:

 kernel/trace/trace.c:385:9: warning: symbol 'trace_seq_to_buffer' was
 not declared. Should it be static?

 kernel/trace/trace_clock.c:29:13: warning: symbol 'trace_clock_local'
 was not declared. Should it be static?

 kernel/trace/trace_clock.c:54:13: warning: symbol 'trace_clock' was not
 declared. Should it be static?

 kernel/trace/trace_clock.c:74:13: warning: symbol 'trace_clock_global'
 was not declared. Should it be static?

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
LKML-Reference: <1237741871-5827-4-git-send-email-dmitri.vorobiev@movial.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c       |    2 +-
 kernel/trace/trace_clock.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e6fac0f..ace685c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -382,7 +382,7 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 	return cnt;
 }
 
-ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
+static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 	void *ret;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 05b176a..b588fd8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/trace_clock.h>
 
 /*
  * trace_clock_local(): the simplest and least coherent tracing clock.
