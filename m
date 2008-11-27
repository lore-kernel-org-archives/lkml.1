Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYK0Klt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYK0Klt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYK0KdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:00 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47271 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYK0KcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:24 -0500
Message-Id: <20081127103135.348578690@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 27/60] remove warnings with functions ending in BUG
Content-Disposition: inline; filename=126-bug-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Functions which end in a BUG() statement and skip the return statement
cause compile warnings on s390, e.g.:

mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:321: warning: control reaches end of non-void function

To avoid the warning add an endless loop to the BUG() macro.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/bug.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/include/asm/bug.h
===================================================================
--- quilt-2.6.orig/arch/s390/include/asm/bug.h
+++ quilt-2.6/arch/s390/include/asm/bug.h
@@ -47,7 +47,10 @@
 
 #endif /* CONFIG_DEBUG_BUGVERBOSE */
 
-#define BUG()	__EMIT_BUG(0)
+#define BUG() do {					\
+	__EMIT_BUG(0);					\
+	for (;;);					\
+} while (0)
 
 #define WARN_ON(x) ({					\
 	int __ret_warn_on = !!(x);			\

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

