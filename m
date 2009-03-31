Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZCaN2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZCaN2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZCaN2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:28:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:6321 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998AbZCaN23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:28:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677480120"
Date: Tue, 31 Mar 2009 15:28:12 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 12/21] x86, ds: defer ds selftests
Message-ID: <20090331152812.A13200@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defer debug store selftests.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 18:52:24.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 19:02:29.000000000 +0200
@@ -1289,26 +1289,6 @@ ds_configure(const struct ds_configurati
 		printk(KERN_INFO "[ds] pebs not available\n");
 	}
 
-	if (ds_cfg.sizeof_rec[ds_bts]) {
-		int error;
-
-		error = ds_selftest_bts();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling bts.\n");
-			ds_cfg.sizeof_rec[ds_bts] = 0;
-		}
-	}
-
-	if (ds_cfg.sizeof_rec[ds_pebs]) {
-		int error;
-
-		error = ds_selftest_pebs();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling pebs.\n");
-			ds_cfg.sizeof_rec[ds_pebs] = 0;
-		}
-	}
-
 	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
 	       8 * ds_cfg.sizeof_ptr_field);
 	printk("bts/pebs record: %u/%u bytes\n",
@@ -1406,3 +1386,29 @@ void ds_copy_thread(struct task_struct *
 void ds_exit_thread(struct task_struct *tsk)
 {
 }
+
+static __init int ds_selftest(void)
+{
+	if (ds_cfg.sizeof_rec[ds_bts]) {
+		int error;
+
+		error = ds_selftest_bts();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling bts.\n");
+			ds_cfg.sizeof_rec[ds_bts] = 0;
+		}
+	}
+
+	if (ds_cfg.sizeof_rec[ds_pebs]) {
+		int error;
+
+		error = ds_selftest_pebs();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling pebs.\n");
+			ds_cfg.sizeof_rec[ds_pebs] = 0;
+		}
+	}
+
+	return 0;
+}
+device_initcall(ds_selftest);
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

