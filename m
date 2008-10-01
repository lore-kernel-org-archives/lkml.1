Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYJAQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYJAQLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYJAQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:11:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:37924 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbYJAQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:11:32 -0400
Message-Id: <20081001160425.577543958@polymtl.ca>
References: <20081001160324.889716972@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 12:03:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@ozlabs.org,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 5/5] sputrace : use marker_synchronize_unregister()
Content-Disposition: inline; filename=sputrace-use-marker-synchronize-unregister.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed,  1 Oct 2008 16:10:57 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a marker_synchronize_unregister() before the end of exit() to make sure
every probe callers have exited the non preemptible section and thus are not
executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Kerr <jk@ozlabs.org>
CC: linuxppc-dev@ozlabs.org
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/platforms/cell/spufs/sputrace.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-07-31 09:34:58.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-07-31 09:35:15.000000000 -0400
@@ -233,6 +233,7 @@ static void __exit sputrace_exit(void)
 
 	remove_proc_entry("sputrace", NULL);
 	kfree(sputrace_log);
+	marker_synchronize_unregister();
 }
 
 module_init(sputrace_init);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
