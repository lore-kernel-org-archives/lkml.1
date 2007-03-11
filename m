Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXCKX3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXCKX3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXCKX3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:29:11 -0400
Received: from ozlabs.org ([203.10.76.45]:48409 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXCKX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:29:10 -0400
Subject: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Jan Beulich <jbeulich@novell.com>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:28:13 +1100
Message-Id: <1173655694.32234.213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON_ZERO is named perfectly wrong, and BUILD_BUG_ON_RETURN_ZERO
is too long.  Flip three bits, and the name is much more suitable.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 6fb745a5bb51 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Mon Mar 12 09:12:20 2007 +1100
+++ b/include/linux/compiler-gcc.h	Mon Mar 12 09:51:18 2007 +1100
@@ -24,7 +24,7 @@
 
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a) \
-  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
+  BUILD_BUG_OR_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
 #define inline		inline		__attribute__((always_inline))
 #define __inline__	__inline__	__attribute__((always_inline))
diff -r 6fb745a5bb51 include/linux/kernel.h
--- a/include/linux/kernel.h	Mon Mar 12 09:12:20 2007 +1100
+++ b/include/linux/kernel.h	Mon Mar 12 09:51:25 2007 +1100
@@ -341,7 +341,7 @@ struct sysinfo {
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_OR_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
diff -r 6fb745a5bb51 include/linux/moduleparam.h
--- a/include/linux/moduleparam.h	Mon Mar 12 09:12:20 2007 +1100
+++ b/include/linux/moduleparam.h	Mon Mar 12 09:51:42 2007 +1100
@@ -65,7 +65,7 @@ struct kparam_array
 #define __module_param_call(prefix, name, set, get, arg, perm)		\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
+	BUILD_BUG_OR_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
 	__attribute_used__						\


