Return-Path: <linux-kernel-owner+w=401wt.eu-S935360AbXGZQks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360AbXGZQks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934524AbXGZQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43110 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934313AbXGZQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:31 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] make __chk_{user,io}_ptr() accept pointers to volatile
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6JF-0005Ny-OV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/compiler.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 12a1291..86f9a3a 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -15,8 +15,8 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
-extern void __chk_user_ptr(const void __user *);
-extern void __chk_io_ptr(const void __iomem *);
+extern void __chk_user_ptr(const volatile void __user *);
+extern void __chk_io_ptr(const volatile void __iomem *);
 #else
 # define __user
 # define __kernel
-- 
1.5.3.GIT


