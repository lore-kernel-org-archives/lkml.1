Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZCPM1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZCPM1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZCPM1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:27:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:23531 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZCPM1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,373,1233561600"; 
   d="scan'208";a="394838557"
Date: Mon, 16 Mar 2009 13:27:31 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch] x86, ds: fix build warning
Message-ID: <20090316132731.A24833@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size_t is defined differently for i386 and x86_64.

Change the index type from size_t to unsigned int to avoid build warnings
on one or the other system.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds_selftest.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds_selftest.c	2009-03-16 09:44:25.000000000 +0100
+++ git-tip/arch/x86/kernel/ds_selftest.c	2009-03-16 12:09:53.000000000 +0100
@@ -86,7 +86,7 @@ static int ds_selftest_bts_read(struct b
 	/* Now to the test itself. */
 	for (at = from; (void *)at < to; at += trace->ds.size) {
 		struct bts_struct bts;
-		size_t index;
+		unsigned long index;
 		int error;
 
 		if (((void *)at - trace->ds.begin) % trace->ds.size) {
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

