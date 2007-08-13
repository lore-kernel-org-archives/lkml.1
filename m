Return-Path: <linux-kernel-owner+w=401wt.eu-S947083AbXHMOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947083AbXHMOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970834AbXHMLmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:42:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971294AbXHMLmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:42:19 -0400
Date: Mon, 13 Aug 2007 07:42:06 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 20/23] make atomic_read() and atomic_set() behavior consistent on sparc
Message-ID: <20070813114206.GT24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on alpha.
Leave sparc-internal atomic24_t type alone.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-sparc/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-sparc/atomic.h	2007-08-13 06:12:49.000000000 -0400
@@ -13,7 +13,7 @@
 
 #include <linux/types.h>
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 #ifdef __KERNEL__
 
@@ -61,7 +61,10 @@ extern int atomic_cmpxchg(atomic_t *, in
 extern int atomic_add_unless(atomic_t *, int, int);
 extern void atomic_set(atomic_t *, int);
 
-#define atomic_read(v)          ((v)->counter)
+static inline int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
 
 #define atomic_add(i, v)	((void)__atomic_add_return( (int)(i), (v)))
 #define atomic_sub(i, v)	((void)__atomic_add_return(-(int)(i), (v)))
