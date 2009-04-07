Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZDGCXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZDGCXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZDGCXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:23:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZDGCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:23:08 -0400
Message-Id: <20090407022305.573899762@goodmis.org>
References: <20090407022242.515462242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 22:22:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] ftrace: Correct a text align for event format output
Content-Disposition: inline; filename=0003-ftrace-Correct-a-text-align-for-event-format-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

If we cat debugfs/tracing/events/ftrace/bprint/format, we'll see:
name: bprint
ID: 6
format:
	field:unsigned char common_type;	offset:0;	size:1;
	field:unsigned char common_flags;	offset:1;	size:1;
	field:unsigned char common_preempt_count;	offset:2;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_tgid;	offset:8;	size:4;

	field:unsigned long ip;	offset:12;	size:4;
	field:char * fmt;	offset:16;	size:4;
	field: char buf;	offset:20;	size:0;

print fmt: "%08lx (%d) fmt:%p %s"

There is an inconsistent blank before char buf.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <49D5E3EE.70201@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_export.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4d9952d..07a22c3 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -40,7 +40,7 @@
 
 #undef TRACE_FIELD_ZERO_CHAR
 #define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield: char " #item ";\t"		\
+	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
 			       "offset:%u;\tsize:0;\n",			\
 			       (unsigned int)offsetof(typeof(field), item)); \
 	if (!ret)							\
-- 
1.6.2.1

-- 
