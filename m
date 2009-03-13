Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZCMLBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZCMLBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZCMLBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:01:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:38994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZCMLBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:01:31 -0400
Date: Fri, 13 Mar 2009 11:00:48 GMT
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313104642.A30149@sedona.ch.intel.com>
References: <20090313104642.A30149@sedona.ch.intel.com>
Subject: [tip:tracing/hw-branch-tracing] x86, bts: correct comment style in ds.c
Message-ID: <tip-b8e47195451c5d3f62620b2b1b5928669afd56eb@git.kernel.org>
Git-Commit-ID: b8e47195451c5d3f62620b2b1b5928669afd56eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 11:00:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8e47195451c5d3f62620b2b1b5928669afd56eb
Gitweb:     http://git.kernel.org/tip/b8e47195451c5d3f62620b2b1b5928669afd56eb
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 13 Mar 2009 10:46:42 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:57:20 +0100

x86, bts: correct comment style in ds.c

Correct the comment style in ds.c.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313104642.A30149@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |   79 ++++++++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 51c936c..d9cab71 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -35,25 +35,22 @@
  * The configuration for a particular DS hardware implementation.
  */
 struct ds_configuration {
-	/* the name of the configuration */
+	/* The name of the configuration. */
 	const char *name;
-	/* the size of one pointer-typed field in the DS structure and
-	   in the BTS and PEBS buffers in bytes;
-	   this covers the first 8 DS fields related to buffer management. */
+	/* The size of pointer-typed fields in DS, BTS, and PEBS. */
 	unsigned char  sizeof_ptr_field;
-	/* the size of a BTS/PEBS record in bytes */
+	/* The size of a BTS/PEBS record in bytes. */
 	unsigned char  sizeof_rec[2];
-	/* a series of bit-masks to control various features indexed
-	 * by enum ds_feature */
+	/* Control bit-masks indexed by enum ds_feature. */
 	unsigned long ctl[dsf_ctl_max];
 };
 static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
 
 #define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
-#define MAX_SIZEOF_DS (12 * 8)	/* maximal size of a DS configuration */
-#define MAX_SIZEOF_BTS (3 * 8)	/* maximal size of a BTS record */
-#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment */
+#define MAX_SIZEOF_DS (12 * 8)	/* Maximal size of a DS configuration. */
+#define MAX_SIZEOF_BTS (3 * 8)	/* Maximal size of a BTS record. */
+#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment. */
 
 #define BTS_CONTROL \
  (ds_cfg.ctl[dsf_bts] | ds_cfg.ctl[dsf_bts_kernel] | ds_cfg.ctl[dsf_bts_user] |\
@@ -67,28 +64,28 @@ static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
  * to identify tracers.
  */
 struct ds_tracer {
-	/* the DS context (partially) owned by this tracer */
+	/* The DS context (partially) owned by this tracer. */
 	struct ds_context *context;
-	/* the buffer provided on ds_request() and its size in bytes */
+	/* The buffer provided on ds_request() and its size in bytes. */
 	void *buffer;
 	size_t size;
 };
 
 struct bts_tracer {
-	/* the common DS part */
+	/* The common DS part. */
 	struct ds_tracer ds;
-	/* the trace including the DS configuration */
+	/* The trace including the DS configuration. */
 	struct bts_trace trace;
-	/* buffer overflow notification function */
+	/* Buffer overflow notification function. */
 	bts_ovfl_callback_t ovfl;
 };
 
 struct pebs_tracer {
-	/* the common DS part */
+	/* The common DS part. */
 	struct ds_tracer ds;
-	/* the trace including the DS configuration */
+	/* The trace including the DS configuration. */
 	struct pebs_trace trace;
-	/* buffer overflow notification function */
+	/* Buffer overflow notification function. */
 	pebs_ovfl_callback_t ovfl;
 };
 
@@ -214,18 +211,16 @@ static inline int check_tracer(struct task_struct *task)
  * deallocated when the last user puts the context.
  */
 struct ds_context {
-	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
+	/* The DS configuration; goes into MSR_IA32_DS_AREA. */
 	unsigned char ds[MAX_SIZEOF_DS];
-	/* the owner of the BTS and PEBS configuration, respectively */
+	/* The owner of the BTS and PEBS configuration, respectively. */
 	struct bts_tracer *bts_master;
 	struct pebs_tracer *pebs_master;
-	/* use count */
+	/* Use count. */
 	unsigned long count;
-	/* a pointer to the context location inside the thread_struct
-	 * or the per_cpu context array */
+	/* Pointer to the context pointer field. */
 	struct ds_context **this;
-	/* a pointer to the task owning this context, or NULL, if the
-	 * context is owned by a cpu */
+	/* The traced task; NULL for current cpu. */
 	struct task_struct *task;
 };
 
@@ -350,14 +345,14 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		unsigned long write_size, adj_write_size;
 
 		/*
-		 * write as much as possible without producing an
+		 * Write as much as possible without producing an
 		 * overflow interrupt.
 		 *
-		 * interrupt_threshold must either be
+		 * Interrupt_threshold must either be
 		 * - bigger than absolute_maximum or
 		 * - point to a record between buffer_base and absolute_maximum
 		 *
-		 * index points to a valid record.
+		 * Index points to a valid record.
 		 */
 		base   = ds_get(context->ds, qual, ds_buffer_base);
 		index  = ds_get(context->ds, qual, ds_index);
@@ -366,8 +361,10 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 
 		write_end = min(end, int_th);
 
-		/* if we are already beyond the interrupt threshold,
-		 * we fill the entire buffer */
+		/*
+		 * If we are already beyond the interrupt threshold,
+		 * we fill the entire buffer.
+		 */
 		if (write_end <= index)
 			write_end = end;
 
@@ -384,7 +381,7 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
 		adj_write_size *= ds_cfg.sizeof_rec[qual];
 
-		/* zero out trailing bytes */
+		/* Zero out trailing bytes. */
 		memset((char *)index + write_size, 0,
 		       adj_write_size - write_size);
 		index += adj_write_size;
@@ -556,7 +553,8 @@ static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
 			     unsigned int flags) {
 	unsigned long buffer, adj;
 
-	/* adjust the buffer address and size to meet alignment
+	/*
+	 * Adjust the buffer address and size to meet alignment
 	 * constraints:
 	 * - buffer is double-word aligned
 	 * - size is multiple of record size
@@ -578,7 +576,8 @@ static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
 	trace->begin = (void *)buffer;
 	trace->top = trace->begin;
 	trace->end = (void *)(buffer + size);
-	/* The value for 'no threshold' is -1, which will set the
+	/*
+	 * The value for 'no threshold' is -1, which will set the
 	 * threshold outside of the buffer, just like we want it.
 	 */
 	trace->ith = (void *)(buffer + size - ith);
@@ -602,7 +601,7 @@ static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 	if (!base)
 		goto out;
 
-	/* we require some space to do alignment adjustments below */
+	/* We require some space to do alignment adjustments below. */
 	error = -EINVAL;
 	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
 		goto out;
@@ -640,7 +639,7 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
 	unsigned long irq;
 	int error;
 
-	/* buffer overflow notification is not yet implemented */
+	/* Buffer overflow notification is not yet implemented. */
 	error = -EOPNOTSUPP;
 	if (ovfl)
 		goto out;
@@ -700,7 +699,7 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 	unsigned long irq;
 	int error;
 
-	/* buffer overflow notification is not yet implemented */
+	/* Buffer overflow notification is not yet implemented. */
 	error = -EOPNOTSUPP;
 	if (ovfl)
 		goto out;
@@ -983,9 +982,9 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 		case 0x1c: /* Atom */
 			ds_configure(&ds_cfg_core2_atom, c);
 			break;
-		case 0x1a: /* i7 */
+		case 0x1a: /* Core i7 */
 		default:
-			/* sorry, don't know about them */
+			/* Sorry, don't know about them. */
 			break;
 		}
 		break;
@@ -997,12 +996,12 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 			ds_configure(&ds_cfg_netburst, c);
 			break;
 		default:
-			/* sorry, don't know about them */
+			/* Sorry, don't know about them. */
 			break;
 		}
 		break;
 	default:
-		/* sorry, don't know about them */
+		/* Sorry, don't know about them. */
 		break;
 	}
 }
