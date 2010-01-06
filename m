Return-Path: <linux-kernel-owner+w=401wt.eu-S932644Ab0AFXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0AFXPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459Ab0AFXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:15:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab0AFXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:33 -0500
X-Authority-Analysis: v=1.0 c=1 a=fN6dPX1LNq8A:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=qpqNgUFuo_7Ap8NDDqcA:9 a=pvHgA0nkKHTYvWtWUSnrxBNeZ_AA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231530.677189845@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/11] tracing: Have __dynamic_array() define a field
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Have-__dynamic_array-define-a-field.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This is part of a patch set that removes the show_format method
in the ftrace event macros.

This patch set requires that all fields are added to the
ftrace_event_call->fields. This patch changes __dynamic_array()
to call trace_define_field() to include fields that use __dynamic_array().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D36.8090100@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_export.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d4fa5dc..9978a4f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -175,7 +175,12 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 		return ret;
 
 #undef __dynamic_array
-#define __dynamic_array(type, item)
+#define __dynamic_array(type, item)					\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 0, is_signed_type(type), FILTER_OTHER);\
+	if (ret)							\
+		return ret;
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
-- 
1.6.5


