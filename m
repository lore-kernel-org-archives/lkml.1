Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbXGNBTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbXGNBTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762033AbXGNBTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:19:16 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:51695 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761811AbXGNBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:19:15 -0400
Date: Fri, 13 Jul 2007 21:19:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86_64 - Use non locked version for local_cmpxchg()
Message-ID: <20070714011913.GB31649@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:18:14 up 6 days, 15:23,  2 users,  load average: 0.35, 0.26, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 - Use non locked version for local_cmpxchg()

local_cmpxchg() should not use any LOCK prefix. This change probably got lost in
the move to cmpxchg.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 include/asm-x86_64/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-x86_64/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cmpxchg.h	2007-07-10 01:10:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cmpxchg.h	2007-07-10 01:11:03.000000000 -0400
@@ -128,7 +128,7 @@
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 #define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
