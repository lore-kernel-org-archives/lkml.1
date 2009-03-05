Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZCEX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZCEX0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZCEX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:26:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33486 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbZCEX0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:26:22 -0500
Message-Id: <20090305225519.788239483@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 36/41] kvm markers API update
Content-Disposition: inline; filename=kvm-markers-api-update.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kvm markers to new API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/kvm_host.h |   12 ++++++------
 virt/kvm/kvm_trace.c     |   12 +++++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/include/linux/kvm_host.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kvm_host.h	2009-03-05 15:21:55.000000000 -0500
+++ linux-2.6-lttng/include/linux/kvm_host.h	2009-03-05 15:49:23.000000000 -0500
@@ -416,22 +416,22 @@ extern struct kvm_stats_debugfs_item deb
 extern struct dentry *kvm_debugfs_dir;
 
 #define KVMTRACE_5D(evt, vcpu, d1, d2, d3, d4, d5, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 5, d1, d2, d3, d4, d5)
 #define KVMTRACE_4D(evt, vcpu, d1, d2, d3, d4, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 4, d1, d2, d3, d4, 0)
 #define KVMTRACE_3D(evt, vcpu, d1, d2, d3, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 3, d1, d2, d3, 0, 0)
 #define KVMTRACE_2D(evt, vcpu, d1, d2, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 2, d1, d2, 0, 0, 0)
 #define KVMTRACE_1D(evt, vcpu, d1, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 1, d1, 0, 0, 0, 0)
 #define KVMTRACE_0D(evt, vcpu, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+	trace_mark(kvm, trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt,\
 						vcpu, 0, 0, 0, 0, 0, 0)
 
 #ifdef CONFIG_KVM_TRACE
Index: linux-2.6-lttng/virt/kvm/kvm_trace.c
===================================================================
--- linux-2.6-lttng.orig/virt/kvm/kvm_trace.c	2009-03-05 15:21:55.000000000 -0500
+++ linux-2.6-lttng/virt/kvm/kvm_trace.c	2009-03-05 15:49:23.000000000 -0500
@@ -48,7 +48,8 @@ static inline int calc_rec_size(int time
 	return timestamp ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
 }
 
-static void kvm_add_trace(void *probe_private, void *call_data,
+static void kvm_add_trace(const struct marker *mdata,
+			  void *probe_private, void *call_private,
 			  const char *format, va_list *args)
 {
 	struct kvm_trace_probe *p = probe_private;
@@ -88,8 +89,8 @@ static void kvm_add_trace(void *probe_pr
 }
 
 static struct kvm_trace_probe kvm_trace_probes[] = {
-	{ "kvm_trace_entryexit", "%u %p %u %u %u %u %u %u", 1, kvm_add_trace },
-	{ "kvm_trace_handler", "%u %p %u %u %u %u %u %u", 0, kvm_add_trace },
+	{ "trace_entryexit", "%u %p %u %u %u %u %u %u", 1, kvm_add_trace },
+	{ "trace_handler", "%u %p %u %u %u %u %u %u", 0, kvm_add_trace },
 };
 
 static int lost_records_get(void *data, u64 *val)
@@ -182,7 +183,8 @@ static int do_kvm_trace_enable(struct kv
 	for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
 		struct kvm_trace_probe *p = &kvm_trace_probes[i];
 
-		r = marker_probe_register(p->name, p->format, p->probe_func, p);
+		r = marker_probe_register("kvm", p->name, p->format,
+					  p->probe_func, p);
 		if (r)
 			printk(KERN_INFO "Unable to register probe %s\n",
 			       p->name);
@@ -250,7 +252,7 @@ void kvm_trace_cleanup(void)
 
 		for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
 			struct kvm_trace_probe *p = &kvm_trace_probes[i];
-			marker_probe_unregister(p->name, p->probe_func, p);
+			marker_probe_unregister("kvm", p->name, p->probe_func, p);
 		}
 		marker_synchronize_unregister();
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
