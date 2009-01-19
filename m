Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZASJjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZASJjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZASJix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:38:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:27081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbZASJiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:38:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,288,1231142400"; 
   d="scan'208";a="379582318"
Date: Mon, 19 Jan 2009 10:38:35 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com
Subject: [patch 6/6] x86, ds, bts: cleanup DS configuration
Message-ID: <20090119103835.A19014@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the cpuid check for DS configuration.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2009-01-12 10:22:03.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2009-01-19 09:54:09.000000000 +0100
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 
@@ -890,7 +890,7 @@ int ds_set_pebs_reset(struct pebs_tracer
 }
 
 static const struct ds_configuration ds_cfg_netburst = {
-	.name = "netburst",
+	.name = "Netburst",
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
@@ -904,7 +904,7 @@ static const struct ds_configuration ds_
 #endif
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
-	.name = "pentium m",
+	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 
 	.sizeof_field		= sizeof(long),
@@ -915,8 +915,8 @@ static const struct ds_configuration ds_
 	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
 #endif
 };
-static const struct ds_configuration ds_cfg_core2 = {
-	.name = "core 2",
+static const struct ds_configuration ds_cfg_core2_atom = {
+	.name = "Core 2/Atom",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 	.ctl[dsf_bts_kernel]	= (1 << 9),
 	.ctl[dsf_bts_user]	= (1 << 10),
@@ -949,19 +949,22 @@ void __cpuinit ds_init_intel(struct cpui
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
-		case 0 ... 0xC:
-			/* sorry, don't know about them */
-			break;
-		case 0xD:
-		case 0xE: /* Pentium M */
+		case 0x9:
+		case 0xd: /* Pentium M */
 			ds_configure(&ds_cfg_pentium_m);
 			break;
-		default: /* Core2, Atom, ... */
-			ds_configure(&ds_cfg_core2);
+		case 0xf:
+		case 0x17: /* Core2 */
+		case 0x1c: /* Atom */
+			ds_configure(&ds_cfg_core2_atom);
+			break;
+		case 0x1a: /* i7 */
+		default:
+			/* sorry, don't know about them */
 			break;
 		}
 		break;
-	case 0xF:
+	case 0xf:
 		switch (c->x86_model) {
 		case 0x0:
 		case 0x1:
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

