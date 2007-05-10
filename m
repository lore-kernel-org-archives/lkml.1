Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXEJBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXEJBYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXEJBXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:23:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49544 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXEJBXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:23:48 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 21:23:47 EDT
Message-Id: <20070510010247.078635958@polymtl.ca>
References: <20070510005935.850493440@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 20:59:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/1] x86_64 : fix default_do_nmi() missing return after a if ()
Content-Disposition: inline; filename=x86_64-fix-default-do-nmi.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 01:02:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Index: linux-2.6-lttng/arch/x86_64/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/traps.c	2007-05-09 17:29:51.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/traps.c	2007-05-09 17:30:07.000000000 -0400
@@ -779,6 +779,7 @@
 			return;
 		if (notify_die(DIE_NMI_POST, "nmi_post", regs, reason, 2, 0)
 								== NOTIFY_STOP)
+			return;
 		if (!do_nmi_callback(regs,cpu))
 			unknown_nmi_error(reason, regs);
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
