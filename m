Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXD0OPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXD0OPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXD0OFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:05:48 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31112 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbXD0OEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:54 -0400
Message-Id: <20070427140511.915140111@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 01/38] memory detection: stop at first memory hole.
Content-Disposition: inline; filename=001-memory-hole.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

If both sclp and diag memory detection don't work stop at the first
memory hole. Otherwise the code might loop forever...

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/kernel/early.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

Index: quilt-2.6/arch/s390/kernel/early.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/early.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/arch/s390/kernel/early.c	2007-04-27 16:04:52.000000000 +0200
@@ -253,11 +253,10 @@
 			break;
 #endif
 		/*
-		 * Finish memory detection at the first hole, unless
-		 * - we reached the hsa -> skip it.
-		 * - we know there must be more.
+		 * Finish memory detection at the first hole
+		 * if storage size is unknown.
 		 */
-		if (cc == -1UL && !memsize && old_addr != ADDR2G)
+		if (cc == -1UL && !memsize)
 			break;
 		if (memsize && addr >= memsize)
 			break;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

