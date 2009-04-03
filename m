Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZDCK2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZDCK2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZDCK2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:28:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZDCK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:28:00 -0400
Message-ID: <49D5E3EE.70201@cn.fujitsu.com>
Date: Fri, 03 Apr 2009 18:24:46 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ftrace: Correct a text align for event format output
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

There is a redundant blank before char buf, and it need to be deleted.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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
1.5.5.3


