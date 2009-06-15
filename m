Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbZFOPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbZFOPob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZFOPoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154411.136115951@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/7] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
Content-Disposition: inline; filename=0004-tracing-replace-a-GFP_ATOMIC-with-GFP_KERNEL-allocat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Atomic allocation is not needed here.

[ Impact: clean up of memory alloction type ]

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A35B898.2050607@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7355a38..0f57f1b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3627,7 +3627,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_seq *s;
 	unsigned long cnt;
 
-	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return ENOMEM;
 
-- 
1.6.3.1

-- 
