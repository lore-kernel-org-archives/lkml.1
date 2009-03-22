Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZCVRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZCVRM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZCVRLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:11:31 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:53877 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZCVRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:11:30 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 3/3] trace: fix four sparse warnings
Date: Sun, 22 Mar 2009 19:11:11 +0200
Message-Id: <1237741871-5827-4-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
 <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
 <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.5.6.3

