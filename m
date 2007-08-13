Return-Path: <linux-kernel-owner+w=401wt.eu-S946886AbXHMOdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946886AbXHMOdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944597AbXHMLdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:33:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944594AbXHMLdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:33:49 -0400
Date: Mon, 13 Aug 2007 07:33:42 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 16/23] make atomic_read() and atomic_set() behavior consistent on s390
Message-ID: <20070813113342.GP24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on s390.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-s390/atomic.h	2007-08-13 03:14:13.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-s390/atomic.h	2007-08-13 06:04:58.000000000 -0400
@@ -67,8 +67,15 @@ typedef struct {
 
 #endif /* __GNUC__ */
 
-#define atomic_read(v)          ((v)->counter)
-#define atomic_set(v,i)         (((v)->counter) = (i))
+static __inline__ int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
+
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+        *(volatile int *)&v->counter = i;
+}
 
 static __inline__ int atomic_add_return(int i, atomic_t * v)
 {
@@ -182,8 +189,15 @@ typedef struct {
 
 #endif /* __GNUC__ */
 
-#define atomic64_read(v)          ((v)->counter)
-#define atomic64_set(v,i)         (((v)->counter) = (i))
+static __inline__ long long atomic64_read(atomic64_t *v)
+{
+        return *(volatile long long *)&v->counter;
+}
+
+static __inline__ void atomic64_set(atomic64_t *v, long long i)
+{
+        *(volatile long long *)&v->counter = i;
+}
 
 static __inline__ long long atomic64_add_return(long long i, atomic64_t * v)
 {
