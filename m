Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXDJWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXDJWXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030457AbXDJWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:23:15 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:58229 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030427AbXDJWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:23:12 -0400
Date: Tue, 10 Apr 2007 18:23:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] atomic-avr32-remove-cast
Message-ID: <20070410222309.GA7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:18:25 up 67 days, 12:25,  4 users,  load average: 1.42, 1.43, 1.65
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic-avr32-remove-cast

This int cast is superfluous since system.h cmpxchg already casts it in
(typeof(*(ptr))).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-avr32/atomic.h
+++ b/include/asm-avr32/atomic.h
@@ -173,7 +173,7 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 }
 
 #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
-#define atomic_cmpxchg(v, o, n)	((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
 
 #define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
 #define atomic_add(i, v)	(void)atomic_add_return(i, v)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
