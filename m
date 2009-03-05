Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZCEH5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZCEH5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZCEH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:57:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:51413 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZCEH53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:57:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,305,1233561600"; 
   d="scan'208";a="116980031"
Date: Thu, 5 Mar 2009 08:57:21 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: [patch] x86, pebs: correct qualifier passed to ds_write_config() from ds_request_pebs()
Message-ID: <20090305085721.A22550@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ds_write_config() can write the BTS as well as the PEBS part of the DS config.
ds_request_pebs() passes the wrong qualifier, which results in the
wrong configuration to be written.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2009-03-04 14:41:15.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2009-03-04 14:49:01.000000000 +0100
@@ -729,7 +729,7 @@ struct pebs_tracer *ds_request_pebs(stru
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
 	ds_resume_pebs(tracer);
 
 	return tracer;
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

