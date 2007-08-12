Return-Path: <linux-kernel-owner+w=401wt.eu-S937906AbXHLTRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937906AbXHLTRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935984AbXHLTRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:17:25 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49051 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935521AbXHLTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:17:24 -0400
Date: Sun, 12 Aug 2007 15:12:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Keith Owens <kaos@ocs.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, tony.luck@intel.com
Subject: [patch 09/23] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64 (revised)
Message-ID: <20070812191211.GA5263@Krystal>
References: <20070812145838.211752593@polymtl.ca> <16002.1186945169@ocs10w.ocs.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <16002.1186945169@ocs10w.ocs.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:11:01 up 13 days, 19:29,  2 users,  load average: 1.70, 2.06, 2.15
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64 (revised)

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
