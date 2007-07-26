Return-Path: <linux-kernel-owner+w=401wt.eu-S935538AbXGZQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935538AbXGZQla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934585AbXGZQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43225 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934580AbXGZQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:51 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] make powerpc BUG_ON() OK with pointers and bitwise
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1IE6JZ-0005QA-R8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since powerpc insists on printing the _value_ of condition
and on casting it to long...  At least let's make it a force-cast.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-powerpc/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-powerpc/bug.h b/include/asm-powerpc/bug.h
index f6fa394..a248b8b 100644
--- a/include/asm-powerpc/bug.h
+++ b/include/asm-powerpc/bug.h
@@ -79,7 +79,7 @@
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__), "i" (0),	\
 		  "i" (sizeof(struct bug_entry)),		\
-		  "r" ((long)(x)));				\
+		  "r" ((__force long)(x)));			\
 	}							\
 } while (0)
 
-- 
1.5.3.GIT


