Return-Path: <linux-kernel-owner+w=401wt.eu-S940781AbXHIOSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940781AbXHIOSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939406AbXHIORk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:17:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940701AbXHIORi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:17:38 -0400
Date: Thu, 9 Aug 2007 09:39:48 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 5/24] make atomic_read() behave consistently on cris
Message-ID: <20070809133948.GA14828@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Purify volatile use for atomic_t on cris.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc2-orig/include/asm-cris/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc2/include/asm-cris/atomic.h	2007-08-09 06:38:28.000000000 -0400
@@ -11,11 +11,15 @@
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v) ((v)->counter)
+/*
+ * Casting to volatile here minimizes the need for barriers,
+ * without having to declare the type itself as volatile.
+ */
+#define atomic_read(v) (*(volatile int *)&(v)->counter)
 #define atomic_set(v,i) (((v)->counter) = (i))
 
 /* These should be written in asm but we do it in C for now. */
