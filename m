Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYBIMEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYBIMEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYBIMDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:03:16 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:4296 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYBIMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:03:09 -0500
Message-Id: <20080209120305.733009610@de.ibm.com>
References: <20080209120157.885371603@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Sat, 09 Feb 2008 13:02:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/11] Fix __ffs_word_loop/__ffz_word_loop inlnie assembly.
Content-Disposition: inline; filename=003-bitops-fix.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The black art of inline assemblies.. The new __ffs_word_loop/
__ffz_word_loop inline assemblies need an early clobber for the
two input/output variables.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/bitops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/include/asm-s390/bitops.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/bitops.h
+++ quilt-2.6/include/asm-s390/bitops.h
@@ -472,7 +472,7 @@ static inline unsigned long __ffz_word_l
 		"	brct	%1,0b\n"
 		"1:\n"
 #endif
-		: "+a" (bytes), "+d" (size)
+		: "+&a" (bytes), "+&d" (size)
 		: "d" (-1UL), "a" (addr), "m" (*(addrtype *) addr)
 		: "cc" );
 	return bytes;
@@ -507,7 +507,7 @@ static inline unsigned long __ffs_word_l
 		"	brct	%1,0b\n"
 		"1:\n"
 #endif
-		: "+a" (bytes), "+a" (size)
+		: "+&a" (bytes), "+&a" (size)
 		: "d" (0UL), "a" (addr), "m" (*(addrtype *) addr)
 		: "cc" );
 	return bytes;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

