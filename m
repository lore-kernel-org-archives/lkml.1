Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZH0Cfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZH0Cfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbZH0Cfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:35:51 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbZH0Cch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=PxY6jGmTHSKvYcMGSYREoaRJDzP9jRwTt9wXKZZDCAfYs+MiLP4h2wA2cUbQ0/TUt6
         reU+Y6EWH5eM5qFkopv0CQ/XXxEsRgF9mxPs086Ut5N99kTcVg60DHcpxQB2xAgnD12u
         dJy0aeHgaEt7Aaho9AeLdNSa/+mlTsKFmQhkw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/18] tracing: Introduce TRACE_FIELD_ZERO() macro
Date: Thu, 27 Aug 2009 04:32:06 +0200
Message-Id: <1251340337-5640-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Use TRACE_FIELD_ZERO(type, item) instead of TRACE_FIELD_ZERO_CHAR(item).
This also includes a typo fix of TRACE_ZERO_CHAR() macro.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
LKML-Reference: <20090813203501.31965.30172.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_event_types.h |    4 ++--
 kernel/trace/trace_export.c      |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 6db005e..e74f090 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -109,7 +109,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(char *, fmt, fmt)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_ZERO(char, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
@@ -117,7 +117,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_ZERO(char, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9cbe7f1..f75faec 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -42,9 +42,9 @@ extern void __bad_type_size(void);
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
 			       "offset:%u;\tsize:0;\n",			\
 			       (unsigned int)offsetof(typeof(field), item)); \
 	if (!ret)							\
@@ -92,9 +92,6 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 
 #include "trace_event_types.h"
 
-#undef TRACE_ZERO_CHAR
-#define TRACE_ZERO_CHAR(arg)
-
 #undef TRACE_FIELD
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
@@ -107,6 +104,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
 	TRACE_FIELD(type, item, assign)
 
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)
+
 #undef TP_CMD
 #define TP_CMD(cmd...)	cmd
 
@@ -180,8 +180,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-- 
1.6.2.3

