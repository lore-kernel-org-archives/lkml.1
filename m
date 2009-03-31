Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbZCaNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbZCaNcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbZCaNbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:31:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:29456 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759398AbZCaNbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:31:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="502280560"
Date: Tue, 31 Mar 2009 15:31:27 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 14/21] x86, ds: fix bounds check in ds selftest
Message-ID: <20090331153127.A13255@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bad bounds check in the debug store selftest.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds_selftest.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds_selftest.c	2009-03-30 19:12:32.000000000 +0200
+++ git-tip/arch/x86/kernel/ds_selftest.c	2009-03-30 19:12:43.000000000 +0200
@@ -55,8 +55,13 @@ static int ds_selftest_bts_consistency(c
 		printk(KERN_CONT "bad bts buffer setup...");
 		error = -1;
 	}
+	/*
+	 * We allow top in [begin; end], since its not clear when the
+	 * overflow adjustment happens: after the increment or before the
+	 * write.
+	 */
 	if ((trace->ds.top < trace->ds.begin) ||
-	    (trace->ds.end <= trace->ds.top)) {
+	    (trace->ds.end < trace->ds.top)) {
 		printk(KERN_CONT "bts top out of bounds...");
 		error = -1;
 	}
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

