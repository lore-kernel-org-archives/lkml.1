Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbYKYHtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbYKYHtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYKYHtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:49:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:9898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKYHtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:49:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="364010918"
Date: Tue, 25 Nov 2008 08:49:06 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 3/9] x86, pebs: fix PEBS record size configuration
Message-ID: <20081125084906.A30995@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the PEBS record size in the DS configuration.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-25 08:17:07.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-25 08:17:57.000000000 +0100
@@ -816,13 +816,21 @@
 	.sizeof_ds    = sizeof(long) * 12,
 	.sizeof_field = sizeof(long),
 	.sizeof_rec[ds_bts]   = sizeof(long) * 3,
+#ifdef __i386__
 	.sizeof_rec[ds_pebs]  = sizeof(long) * 10
+#else
+	.sizeof_rec[ds_pebs]  = sizeof(long) * 18
+#endif
 };
 static const struct ds_configuration ds_cfg_64 = {
 	.sizeof_ds    = 8 * 12,
 	.sizeof_field = 8,
 	.sizeof_rec[ds_bts]   = 8 * 3,
+#ifdef __i386__
 	.sizeof_rec[ds_pebs]  = 8 * 10
+#else
+	.sizeof_rec[ds_pebs]  = 8 * 18
+#endif
 };
 
 static inline void
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

