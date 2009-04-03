Return-Path: <linux-kernel-owner+w=401wt.eu-S934228AbZDCOx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbZDCOx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZDCOqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:54031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788AbZDCOqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:10 -0400
Content-Type: multipart/mixed; boundary="===============0810507704=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328379"
Message-Id: <20090403144604.256645000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:49 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 17/20] x86, ds: dont use TIF_DEBUGCTLMSR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0810507704==
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
@@ -925,11 +925,6 @@ static void update_task_debugctlmsr(stru
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

--===============0810507704==
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

--===============0810507704==--
