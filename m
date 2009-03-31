Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbZCaNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbZCaNYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZCaNYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:24:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:1077 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888AbZCaNYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677479277"
Date: Tue, 31 Mar 2009 15:23:39 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 10/21] x86, ptrace: use new debug store interface
Message-ID: <20090331152339.A13115@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the ptrace bts code use the new debug store interface
introduced in patch 7.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ptrace.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ptrace.c	2009-03-31 13:26:53.000000000 +0200
+++ git-tip/arch/x86/kernel/ptrace.c	2009-03-31 13:29:12.000000000 +0200
@@ -798,8 +798,9 @@ static int ptrace_bts_config(struct task
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		flags |= BTS_TIMESTAMPS;
 
-	context->tracer = ds_request_bts(child, context->buffer, context->size,
-					 NULL, (size_t)-1, flags);
+	context->tracer =
+		ds_request_bts_task(child, context->buffer, context->size,
+				    NULL, (size_t)-1, flags);
 	if (unlikely(IS_ERR(context->tracer))) {
 		int error = PTR_ERR(context->tracer);
 
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

