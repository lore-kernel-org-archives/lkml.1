Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbXLaSHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbXLaSHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXLaSHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:07:23 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36842 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXLaSHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:07:22 -0500
Date: Mon, 31 Dec 2007 10:05:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       davem@davemloft.net
Subject: [PATCH -mm] crypto: scatterwalk.h needs sched.h
Message-Id: <20071231100539.0a782c40.randy.dunlap@oracle.com>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PREEMPT_NONE=y, scatterwalk.h still uses cond_resched()
so it needs to include sched.h:

linux-2.6.24-rc6-mm1/include/crypto/scatterwalk.h:52: error: implicit declaration of function 'cond_resched'
make[2]: *** [crypto/digest.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/crypto/scatterwalk.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc6-mm1.orig/include/crypto/scatterwalk.h
+++ linux-2.6.24-rc6-mm1/include/crypto/scatterwalk.h
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/sched.h>
 
 static inline enum km_type crypto_kmap_type(int out)
 {
