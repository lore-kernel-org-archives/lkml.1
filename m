Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYDJOmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYDJOmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbYDJOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:41:37 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbYDJOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:35 -0400
Message-Id: <20080410134827.771251000@sipsolutions.net>
References: <20080410134810.629048000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Thu, 10 Apr 2008 15:48:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC 1/3] add macros for new sparse features
Content-Disposition: inline; filename=011-kernel-add-new-sparse-stuff.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kernel macros for a few new sparse features, namely
 * checking try_lock functions and
 * making a function or macro require a certain lock.

Still waiting to see what the sparse folks say to my patches.

Not-yet-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/compiler.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- everything.orig/include/linux/compiler.h	2008-04-10 15:36:18.000000000 +0200
+++ everything/include/linux/compiler.h	2008-04-10 15:36:40.000000000 +0200
@@ -11,9 +11,12 @@
 # define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(2)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
+# define __try_acquires(x,t,f)	__attribute__((conditional_context(x,0,t,f)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
+# define __requires(x)	__attribute__((context(x,1,1)))
+# define __macro_requires(x)	__context__(x,0,1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
@@ -28,9 +31,12 @@ extern void __chk_io_ptr(const volatile 
 # define __chk_io_ptr(x) (void)0
 # define __builtin_warning(x, y...) (1)
 # define __acquires(x)
+# define __try_acquires(x,t,f)
 # define __releases(x)
 # define __acquire(x) (void)0
 # define __release(x) (void)0
+# define __requires(x)
+# define __macro_requires(x)
 # define __cond_lock(x,c) (c)
 #endif
 

-- 

