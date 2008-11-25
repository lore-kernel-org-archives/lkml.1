Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYKYIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYKYIJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYKYIIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:08:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:48436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKYIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:08:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407757038"
Date: Tue, 25 Nov 2008 09:08:47 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 7/9] x86, pebs: export ds.c symbols
Message-ID: <20081125090847.A31384@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export symbols in ds.c.

The changes are required to allow perfmon2 to access DS.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-25 08:18:03.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-25 08:18:04.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 
 /*
@@ -419,6 +420,7 @@
  out:
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(ds_request_bts);
 
 struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 				    void *base, size_t size,
@@ -449,6 +451,7 @@
  out:
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(ds_request_pebs);
 
 static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
 {
@@ -469,6 +472,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_release_bts);
 
 int ds_release_pebs(struct pebs_tracer *tracer)
 {
@@ -480,6 +484,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_release_pebs);
 
 static size_t ds_get_index(struct ds_context *context, enum ds_qualifier qual)
 {
@@ -503,6 +508,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_get_bts_index);
 
 int ds_get_pebs_index(struct pebs_tracer *tracer, size_t *pos)
 {
@@ -516,6 +522,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_get_pebs_index);
 
 static size_t ds_get_end(struct ds_context *context, enum ds_qualifier qual)
 {
@@ -539,6 +546,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_get_bts_end);
 
 int ds_get_pebs_end(struct pebs_tracer *tracer, size_t *pos)
 {
@@ -552,6 +560,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_get_pebs_end);
 
 static int ds_access(struct ds_context *context, enum ds_qualifier qual,
 		     size_t index, const void **record)
@@ -580,6 +589,7 @@
 
 	return ds_access(tracer->ds.context, ds_bts, index, record);
 }
+EXPORT_SYMBOL(ds_access_bts);
 
 int ds_access_pebs(struct pebs_tracer *tracer, size_t index,
 		   const void **record)
@@ -589,6 +599,7 @@
 
 	return ds_access(tracer->ds.context, ds_pebs, index, record);
 }
+EXPORT_SYMBOL(ds_access_pebs);
 
 static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		    const void *record, size_t size)
@@ -660,6 +671,7 @@
 
 	return ds_write(tracer->ds.context, ds_bts, record, size);
 }
+EXPORT_SYMBOL(ds_write_bts);
 
 int ds_write_pebs(struct pebs_tracer *tracer, const void *record, size_t size)
 {
@@ -668,6 +680,7 @@
 
 	return ds_write(tracer->ds.context, ds_pebs, record, size);
 }
+EXPORT_SYMBOL(ds_write_pebs);
 
 static void ds_reset_or_clear(struct ds_context *context,
 			      enum ds_qualifier qual, int clear)
@@ -692,6 +705,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_reset_bts);
 
 int ds_reset_pebs(struct pebs_tracer *tracer)
 {
@@ -702,6 +716,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_reset_pebs);
 
 int ds_clear_bts(struct bts_tracer *tracer)
 {
@@ -712,6 +727,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_clear_bts);
 
 int ds_clear_pebs(struct pebs_tracer *tracer)
 {
@@ -722,6 +738,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_clear_pebs);
 
 int ds_get_pebs_reset(struct pebs_tracer *tracer, u64 *value)
 {
@@ -735,6 +752,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_get_pebs_reset);
 
 int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
 {
@@ -745,6 +763,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(ds_set_pebs_reset);
 
 static const struct ds_configuration ds_cfg_var = {
 	.sizeof_ds    = sizeof(long) * 12,
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

