Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYBLW7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYBLW7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYBLW7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:59:35 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:64093 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbYBLW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:59:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAA20sUdMQWYv/2dsb2JhbACBWY8qnCk
Date: Tue, 12 Feb 2008 17:59:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, penberg@cs.helsinki.fi,
       tglx@linutronix.de, vegard.nossum@gmail.com
Subject: Cast cmpxchg64 and cmpxchg64_local result for 386 and 486 - Fix
	missing parenthesis
Message-ID: <20080212225929.GA20933@Krystal>
References: <200802122200.m1CM0YZY024502@imap1.linux-foundation.org> <Pine.LNX.4.64.0802121404470.9183@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802121404470.9183@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:58:01 up 1 day, 18:58,  3 users,  load average: 0.06, 0.61,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two pairs of parenthesis were missing around the result cast of cmpxchg64 and
cmpxchg64_local. This is a rather stupid mistake in
"Cast cmpxchg and cmpxchg_local result for 386 and 486". My bad. This fix
should be folded with the previous.

Sorry for this trivial bug which should have never appeared in the first place.
The aim was to fix cmpxchg and cmpxchg_local, which were used in slub. cmpxchg64
and cmpxchg64_local happen to be only used in LTTng currently.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
CC: akpm@linux-foundation.org
---
 include/asm-x86/cmpxchg_32.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/cmpxchg_32.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/cmpxchg_32.h	2008-02-12 17:49:32.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/cmpxchg_32.h	2008-02-12 17:50:18.000000000 -0500
@@ -305,11 +305,11 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __typeof__(*(ptr))__cmpxchg64((ptr),		\
+		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
@@ -318,11 +318,11 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __typeof__(*(ptr))__cmpxchg64_local((ptr),	\
+		__ret = (__typeof__(*(ptr)))__cmpxchg64_local((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
