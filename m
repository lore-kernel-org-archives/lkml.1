Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXCLI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXCLI0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCLI0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:26:19 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:15473
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965292AbXCLI0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:26:18 -0400
Message-Id: <45F51C25.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Mar 2007 08:23:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Andi Kleen" <ak@muc.de>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
References: <1173655694.32234.213.camel@localhost.localdomain>
In-Reply-To: <1173655694.32234.213.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have to admit that I don't see the point here - I can't seem to make any sense of the OR... Jan

>>> Rusty Russell <rusty@rustcorp.com.au> 12.03.07 00:28 >>>
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


