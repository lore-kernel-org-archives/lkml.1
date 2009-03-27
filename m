Return-Path: <linux-kernel-owner+w=401wt.eu-S1751102AbZC0JO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbZC0JO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZC0JOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:14:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:62109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZC0JOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="676463324"
Date: Fri, 27 Mar 2009 10:14:42 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 8/14] x86, ds: fix bounds check in ds selftest
Message-ID: <20090327101442.A11521@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a bts index equal to max. We don't know how the hardware implements
the index wrap-around.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds_selftest.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds_selftest.c	2009-03-20 14:05:51.000000000 +0100
+++ git-tip/arch/x86/kernel/ds_selftest.c	2009-03-20 14:05:56.000000000 +0100
@@ -47,8 +47,13 @@
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

