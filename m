Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZFESJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZFESJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZFESJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:09:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbZFESJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:09:39 -0400
Date: Fri, 5 Jun 2009 14:08:04 -0400
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <2c9a74b51d467fcd1e19ffeca35d721bda158d2e.1244222378.git.jbaron@redhat.com>
In-Reply-To: <cover.1244222378.git.jbaron@redhat.com>
References: <cover.1244222378.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/2] allow TP_printk() to have no args
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows TP_printk() to take no args. otherwise there is a stray
',' which causes a compile error.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index edb02bc..d861e21 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -114,7 +114,7 @@
 #define __entry field
 
 #undef TP_printk
-#define TP_printk(fmt, args...) fmt "\n", args
+#define TP_printk(fmt, ...) fmt "\n", ##__VA_ARGS__
 
 #undef __get_str
 #define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
-- 
1.6.0.6

