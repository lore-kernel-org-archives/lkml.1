Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZDGNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZDGNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZDGNO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:14:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013AbZDGNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:14:26 -0400
Date: Tue, 7 Apr 2009 13:13:47 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49D5E3EE.70201@cn.fujitsu.com>
References: <49D5E3EE.70201@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Correct a text align for event format output
Message-ID: <tip-1bbe2a83ab68e5cf8c66c372c7cb3b51910c2cfe@git.kernel.org>
Git-Commit-ID: 1bbe2a83ab68e5cf8c66c372c7cb3b51910c2cfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bbe2a83ab68e5cf8c66c372c7cb3b51910c2cfe
Gitweb:     http://git.kernel.org/tip/1bbe2a83ab68e5cf8c66c372c7cb3b51910c2cfe
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 3 Apr 2009 18:24:46 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:02:42 +0200

ftrace: Correct a text align for event format output

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
