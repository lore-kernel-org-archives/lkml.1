Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXHMOb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXHMOb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944057AbXHMLbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:31:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943765AbXHMLba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:31:30 -0400
Date: Mon, 13 Aug 2007 07:31:10 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 15/23] make atomic_read() and atomic_set() behavior consistent on parisc
Message-ID: <20070813113110.GO24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on parisc.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-parisc/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-parisc/atomic.h	2007-08-13 05:59:35.000000000 -0400
@@ -128,7 +128,7 @@ __cmpxchg(volatile void *ptr, unsigned l
  * Cache-line alignment would conflict with, for example, linux/module.h
  */
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 /* It's possible to reduce all atomic operations to either
  * __atomic_add_return, atomic_set and atomic_read (the latter
@@ -159,7 +159,7 @@ static __inline__ void atomic_set(atomic
 
 static __inline__ int atomic_read(const atomic_t *v)
 {
-	return v->counter;
+	return *(volatile int *)&v->counter;
 }
 
 /* exported interface */
@@ -227,7 +227,7 @@ static __inline__ int atomic_add_unless(
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile s64 counter; } atomic64_t;
+typedef struct { s64 counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
 
@@ -258,7 +258,7 @@ atomic64_set(atomic64_t *v, s64 i)
 static __inline__ s64
 atomic64_read(const atomic64_t *v)
 {
-	return v->counter;
+	return *(volatile s64 *)&v->counter;
 }
 
 #define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)i),(v))))
