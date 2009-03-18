Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZCRS6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZCRS6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbZCRS6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:58:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:51715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbZCRS6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:58:06 -0400
Date: Wed, 18 Mar 2009 18:57:28 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237394936.3132.1.camel@localhost.localdomain>
References: <1237394936.3132.1.camel@localhost.localdomain>
Subject: [tip:tracing/ftrace] tracepoints: dont update zero-sized tracepoint sections
Message-ID: <tip-ec625cb29e66824f7ce41082617aeb93fa4e42e2@git.kernel.org>
Git-Commit-ID: ec625cb29e66824f7ce41082617aeb93fa4e42e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 18:57:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec625cb29e66824f7ce41082617aeb93fa4e42e2
Gitweb:     http://git.kernel.org/tip/ec625cb29e66824f7ce41082617aeb93fa4e42e2
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 18 Mar 2009 19:54:04 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 19:55:00 +0100

tracepoints: dont update zero-sized tracepoint sections

Zero-sized tracepoint sections can occur if tracing is enabled but
no tracepoint is defined. Do not emit a warning in that case.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1237394936.3132.1.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/tracepoint.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index adf2873..1ef5d3a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -278,10 +278,8 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 	struct tracepoint *iter;
 	struct tracepoint_entry *mark_entry;
 
-	if (!begin) {
-		WARN_ON_ONCE(1);
+	if (!begin)
 		return;
-	}
 
 	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
