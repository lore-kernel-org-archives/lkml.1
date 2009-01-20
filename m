Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbZATAWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbZATAWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764103AbZATARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764793AbZATARf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:35 -0500
Message-Id: <20090120001733.589582850@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/8] x86, ds, bts: cleanup DS configuration
Content-Disposition: inline; filename=0006-x86-ds-bts-cleanup-DS-configuration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

Cleanup the cpuid check for DS configuration.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ds.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index da91701..169a120 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 
@@ -890,7 +890,7 @@ int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
 }
 
 static const struct ds_configuration ds_cfg_netburst = {
-	.name = "netburst",
+	.name = "Netburst",
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
@@ -904,7 +904,7 @@ static const struct ds_configuration ds_cfg_netburst = {
 #endif
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
-	.name = "pentium m",
+	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 
 	.sizeof_field		= sizeof(long),
@@ -915,8 +915,8 @@ static const struct ds_configuration ds_cfg_pentium_m = {
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
@@ -949,19 +949,22 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
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
-- 
1.5.6.5

-- 
