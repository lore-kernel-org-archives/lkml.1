Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbXH0QJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbXH0QJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbXH0QAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:00:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43736 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899AbXH0QAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:00:42 -0400
Message-Id: <20070827155527.817330797@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       tony.luck@intel.com, Keith Owens <kaos@ocs.com.au>
Subject: [patch 13/28] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
Content-Disposition: inline; filename=add-cmpxchg-local-to-ia64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
use cmpxchg_acq as underlying macro, just like the already existing ia64
cmpxchg().

Changelog:

ia64 cmpxchg_local coding style fix
Quoting Keith Owens:

As a matter of coding style, I prefer

#define cmpxchg_local   cmpxchg
#define cmpxchg64_local cmpxchg64

Which makes it absolutely clear that they are the same code.  With your
patch, humans have to do a string compare of two defines to see if they
are the same.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: tony.luck@intel.com
CC: Keith Owens <kaos@ocs.com.au>
---
 include/asm-ia64/intrinsics.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/include/asm-ia64/intrinsics.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/intrinsics.h	2007-08-12 09:33:57.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/intrinsics.h	2007-08-12 15:09:49.000000000 -0400
@@ -158,6 +158,10 @@ extern long ia64_cmpxchg_called_with_bad
 
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+#define cmpxchg64(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+
+#define cmpxchg_local		cmpxchg
+#define cmpxchg64_local		cmpxchg64
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
