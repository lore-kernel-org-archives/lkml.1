Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbZCaOdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbZCaOdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbZCaOda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:33:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:11071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbZCaOd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677497616"
Date: Tue, 31 Mar 2009 15:44:01 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 19/21] x86, ds: don't use TIF_DEBUGCTLMSR
Message-ID: <20090331154401.A13522@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debug store already uses TIF_DS_AREA_MSR to trigger debug store context
switch handling. No need to use TIF_DEBUGCTLMSR, as well.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 19:14:51.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 19:26:02.000000000 +0200
@@ -956,11 +956,6 @@ static void update_task_debugctlmsr(stru
 	get_cpu();
 	if (task == current)
 		update_debugctlmsr(debugctlmsr);
-
-	if (task->thread.debugctlmsr)
-		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	else
-		clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
 	put_cpu();
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

