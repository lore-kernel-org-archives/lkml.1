Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZCED2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZCED2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZCED1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZCED1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:15 -0500
Message-Id: <20090305032712.999790054@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] tracing: fix seq read from trace files
Content-Disposition: inline; filename=0003-tracing-fix-seq-read-from-trace-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The buffer used by trace_seq was updated incorrectly. Instead
of consuming what was actually read, it consumed the rest of the
buffer on reads.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 57155dc..2e53e6f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -361,7 +361,7 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 
 	cnt -= ret;
 
-	s->readpos += len;
+	s->readpos += cnt;
 	return cnt;
 }
 
@@ -380,7 +380,7 @@ ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	if (!ret)
 		return -EFAULT;
 
-	s->readpos += len;
+	s->readpos += cnt;
 	return cnt;
 }
 
-- 
1.6.1.3

-- 
