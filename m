Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355Ab0AMKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0AMKWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335Ab0AMKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:22:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:37817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab0AMKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:22:08 -0500
Date: Wed, 13 Jan 2010 10:21:33 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B273D36.8090100@cn.fujitsu.com>
References: <4B273D36.8090100@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Have __dynamic_array() define a field
Message-ID: <tip-809826a389040e0ad9d646b587bccc0e34691afd@git.kernel.org>
Git-Commit-ID: 809826a389040e0ad9d646b587bccc0e34691afd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:21:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  809826a389040e0ad9d646b587bccc0e34691afd
Gitweb:     http://git.kernel.org/tip/809826a389040e0ad9d646b587bccc0e34691afd
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:34 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 11:30:02 -0500

tracing: Have __dynamic_array() define a field

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
