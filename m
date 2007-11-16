Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbXKPO1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbXKPO1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbXKPOZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:25:38 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55617 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761787AbXKPOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:25:30 -0500
Message-Id: <20071116142527.937138444@de.ibm.com>
References: <20071116142441.484714036@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:24:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/10] Fix memory detection.
Content-Disposition: inline; filename=010-memsize.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Before we're getting short on memory detection fixes here is the next
one: if neither sclp nor diag260 report the storage size the detection
loop will return immediately without detecting anything. Fix this by
breaking the detection loop only if the memory end is known.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	2007-11-16 14:27:30.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-11-16 14:27:45.000000000 +0100
@@ -200,7 +200,7 @@ static noinline __init void find_memory_
 		cc = __tprot(addr);
 		while (cc == old_cc) {
 			addr += CHUNK_INCR;
-			if (addr >= memsize)
+			if (memsize && addr >= memsize)
 				break;
 #ifndef CONFIG_64BIT
 			if (addr == ADDR2G)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

