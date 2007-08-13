Return-Path: <linux-kernel-owner+w=401wt.eu-S1031482AbXHMONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031482AbXHMONR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944184AbXHMLO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:14:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944180AbXHMLO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:14:27 -0400
Date: Mon, 13 Aug 2007 07:14:11 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 6/23] make atomic_read() and atomic_set() behavior consistent on cris
Message-ID: <20070813111411.GF24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on cris.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-cris/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-cris/atomic.h	2007-08-13 05:23:37.000000000 -0400
@@ -11,12 +11,19 @@
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v) ((v)->counter)
-#define atomic_set(v,i) (((v)->counter) = (i))
+static inline int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
+
+static inline void atomic_set(atomic_t *v, int i)
+{
+        *(volatile int *)&v->counter = i;
+}
 
 /* These should be written in asm but we do it in C for now. */
 
