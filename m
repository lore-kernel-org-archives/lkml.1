Return-Path: <linux-kernel-owner+w=401wt.eu-S934317AbXHMOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbXHMOKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940257AbXHMLLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:11:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXHMLL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:11:29 -0400
Date: Mon, 13 Aug 2007 07:11:18 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 4/23] make atomic_read() and atomic_set() behavior consistent on avr32
Message-ID: <20070813111118.GD24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on avr32.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-avr32/atomic.h	2007-08-13 03:14:13.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-avr32/atomic.h	2007-08-13 04:48:25.000000000 -0400
@@ -16,11 +16,18 @@
 
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v)		((v)->counter)
-#define atomic_set(v, i)	(((v)->counter) = i)
+static inline int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
+
+static inline void atomic_set(atomic_t *v, int i)
+{
+        *(volatile int *)&v->counter = i;
+}
 
 /*
  * atomic_sub_return - subtract the atomic variable
