Return-Path: <linux-kernel-owner+w=401wt.eu-S939850AbXHINdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939850AbXHINdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939230AbXHINcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:32:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938397AbXHINcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:32:50 -0400
Date: Thu, 9 Aug 2007 09:32:18 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 3/24] make atomic_read() behave consistently on avr32
Message-ID: <20070809133218.GA14163@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Purify volatile use for atomic_t on avr32.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc2-orig/include/asm-avr32/atomic.h	2007-08-08 17:48:52.000000000 -0400
+++ linux-2.6.23-rc2/include/asm-avr32/atomic.h	2007-08-09 06:33:39.000000000 -0400
@@ -16,10 +16,14 @@
 
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v)		((v)->counter)
+/*
+ * Casting to volatile here minimizes the need for barriers,
+ * without having to declare the type itself as volatile.
+ */
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 /*
