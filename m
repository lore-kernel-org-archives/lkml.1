Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbXH1UkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbXH1UkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXH1UkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:40:11 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:33121 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbXH1UkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:40:09 -0400
Date: Tue, 28 Aug 2007 16:40:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Powerpc Optimization Fix
Message-ID: <20070828204006.GD10071@Krystal>
References: <20070820202355.684760993@polymtl.ca> <20070820202538.765121428@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070820202538.765121428@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:39:10 up 29 days, 20:58,  5 users,  load average: 2.78, 1.30, 0.97
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values Powerpc Optimization Fix

Fix a bad call to flush_icache_range(). The second parameter is the end address
of the range, not the length.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/kernel/immediate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/immediate.c	2007-08-28 16:36:10.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/immediate.c	2007-08-28 16:36:40.000000000 -0400
@@ -67,7 +67,7 @@ int arch_immediate_update(const struct _
 	memcpy((void*)immediate->immediate, (void*)immediate->var,
 			immediate->size);
 	flush_icache_range((unsigned long)immediate->immediate,
-				immediate->size);
+		(unsigned long)immediate->immediate + immediate->size);
 	return 0;
 }
 
@@ -99,5 +99,5 @@ void __init arch_immediate_update_early(
 	memcpy((void*)immediate->immediate, (void*)immediate->var,
 			immediate->size);
 	flush_icache_range((unsigned long)immediate->immediate,
-				immediate->size);
+		(unsigned long)immediate->immediate + immediate->size);
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
