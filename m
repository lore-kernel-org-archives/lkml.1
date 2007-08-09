Return-Path: <linux-kernel-owner+w=401wt.eu-S939582AbXHINuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939582AbXHINuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764050AbXHINtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:49:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762051AbXHINtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:49:51 -0400
Date: Thu, 9 Aug 2007 09:49:14 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 8/24] make atomic_read() behave consistently on i386
Message-ID: <20070809134914.GA15811@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Make atomic_read() volatile on i386, to ensure memory is actually read
each time.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc2-orig/include/asm-i386/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc2/include/asm-i386/atomic.h	2007-08-09 06:47:47.000000000 -0400
@@ -25,7 +25,7 @@ typedef struct { int counter; } atomic_t
  * 
  * Atomically reads the value of @v.
  */ 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 
 /**
  * atomic_set - set atomic variable
