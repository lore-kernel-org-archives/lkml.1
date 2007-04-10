Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXDJWdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXDJWdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXDJWdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:33:04 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:61100 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030628AbXDJWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:33:01 -0400
Date: Tue, 10 Apr 2007 18:27:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] atomic-powerpc-remove-double-defines
Message-ID: <20070410222753.GB7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:23:11 up 67 days, 12:30,  5 users,  load average: 1.16, 1.37, 1.57
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated defines in asm-powerpc/atomic.h. atomic64_inc_not_zero
and atomic64_xchg are defined twice. It also removes an unnecessary cast
to the atomic_cmpxchg result, which is already done by system.h cmpxchg.

It applies on 2.6.21-rc6-mm1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/atomic.h
+++ b/include/asm-powerpc/atomic.h
@@ -166,8 +166,7 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 	return t;
 }
 
-#define atomic_cmpxchg(v, o, n) \
-	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -415,12 +414,7 @@ static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
 	return t;
 }
 
-#define atomic64_cmpxchg(v, o, n) \
-	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
-#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
-
-#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
-
+#define atomic64_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
