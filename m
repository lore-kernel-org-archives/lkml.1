Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZCaOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZCaOdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZCaOdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:33:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:31956 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbZCaOdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:33:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677497600"
Date: Tue, 31 Mar 2009 15:46:03 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 20/21] x86, ds: fix bad ds_reset_pebs
Message-ID: <20090331154603.A13545@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ds_reset_pebs() passed the wrong qualifier to a shared function resulting
in a reset of bts, rather than pebs.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-31 13:35:23.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-31 13:35:54.000000000 +0200
@@ -1217,7 +1217,7 @@ int ds_reset_pebs(struct pebs_tracer *tr
 
 	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	ds_set(tracer->ds.context->ds, ds_pebs, ds_index,
 	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;
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

