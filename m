Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbZDBPDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbZDBPDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761011AbZDBO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:57531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761530AbZDBO5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:40 -0400
Content-Type: multipart/mixed; boundary="===============1877425519=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="444386167"
Message-Id: <20090402145732.358606000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:55:11 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 16/18] x86, ds: dont use TIF_DEBUGCTLMSR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1877425519==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.tif_debugctlmsr.patch

Debug store already uses TIF_DS_AREA_MSR to trigger debug store context
switch handling. No need to use TIF_DEBUGCTLMSR, as well.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c |    5 	0 +	5 -	0 !
 1 file changed, 5 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -953,11 +953,6 @@ static void update_task_debugctlmsr(stru
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
 

-- 

--===============1877425519==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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

--===============1877425519==--
