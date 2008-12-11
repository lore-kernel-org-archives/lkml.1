Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYLKMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYLKMpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYLKMph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:45:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:39646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYLKMpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,753,1220252400"; 
   d="scan'208";a="89039310"
Date: Thu, 11 Dec 2008 13:45:23 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: [patch 1/3] x86, bts: turn BUG_ON into WARN_ON_ONCE
Message-ID: <20081211134523.A13571@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn BUG_ON's into WARN_ON_ONCE.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-12-08 09:42:53.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-12-08 13:29:03.000000000 +0100
@@ -452,7 +452,7 @@
 
 static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
 {
-	BUG_ON(tracer->context->owner[qual] != tracer);
+	WARN_ON_ONCE(tracer->context->owner[qual] != tracer);
 	tracer->context->owner[qual] = NULL;
 
 	put_tracer(tracer->context->task);
@@ -774,7 +774,7 @@
 
 	printk(KERN_INFO "DS available\n");
 
-	BUG_ON(MAX_SIZEOF_DS < ds_cfg.sizeof_ds);
+	WARN_ON_ONCE(MAX_SIZEOF_DS < ds_cfg.sizeof_ds);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-12-08 09:42:53.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-12-08 13:29:03.000000000 +0100
@@ -878,7 +878,8 @@
 {
 	unsigned char bts_record[BTS_MAX_RECORD_SIZE];
 
-	BUG_ON(BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts);
+	if (BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts)
+		return -EOVERFLOW;
 
 	memset(bts_record, 0, bts_cfg.sizeof_bts);
 	switch (in->qualifier) {
@@ -1133,7 +1134,7 @@
 
 		ret = ds_get_bts_index(child->bts, &size);
 		if (ret == 0) {
-			BUG_ON(size != (int) size);
+			WARN_ON_ONCE(size != (int) size);
 			ret = (int) size;
 		}
 		break;
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

