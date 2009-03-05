Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZCEHuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZCEHuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZCEHuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:50:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:55321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZCEHuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:50:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,305,1233561600"; 
   d="scan'208";a="391824806"
Date: Thu, 5 Mar 2009 08:49:54 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch, for 2.6.29] x86, bts: remove bad warning
Message-ID: <20090305084954.A22000@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a ptraced task is reaped (while the tracer is still attached),
ds_exit_thread() is called before ptrace_exit(). The latter will
release the bts_tracer and remove the thread's ds_ctx.
The former will WARN() if the context is not NULL.

Oleg Nesterov submitted patches that move ptrace_exit() before
exit_thread() and thus reverse the order of the above calls.

Remove the bad warning. I will add it again when Oleg's changes are in.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2009-03-05 08:14:38.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2009-03-05 08:15:21.000000000 +0100
@@ -1029,5 +1029,4 @@ void ds_copy_thread(struct task_struct *
 
 void ds_exit_thread(struct task_struct *tsk)
 {
-	WARN_ON(tsk->thread.ds_ctx);
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

