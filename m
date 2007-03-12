Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXCLIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXCLIlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXCLIlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:41:32 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45319 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965351AbXCLIlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:41:31 -0400
Date: Mon, 12 Mar 2007 09:39:12 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jan Beulich <jbeulich@novell.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
In-Reply-To: <45F51C25.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.61.0703120938190.19469@yvahk01.tjqt.qr>
References: <1173655694.32234.213.camel@localhost.localdomain>
 <45F51C25.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12 2007 08:23, Jan Beulich wrote:
>
>I have to admit that I don't see the point here - I can't seem to make any
>sense of the OR... Jan

BUILD_BUG_OR_ZERO will either (a) result in a build bug or (b) the number
zero, suitable for arithmetic.

>>>> Rusty Russell <rusty@rustcorp.com.au> 12.03.07 00:28 >>>
>BUILD_BUG_ON_ZERO is named perfectly wrong, and BUILD_BUG_ON_RETURN_ZERO
>is too long.  Flip three bits, and the name is much more suitable.
>
>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
>diff -r 6fb745a5bb51 include/linux/compiler-gcc.h
>--- a/include/linux/compiler-gcc.h	Mon Mar 12 09:12:20 2007 +1100
>+++ b/include/linux/compiler-gcc.h	Mon Mar 12 09:51:18 2007 +1100
>@@ -24,7 +24,7 @@
> 
> /* &a[0] degrades to a pointer: a different type from an array */
> #define __must_be_array(a) \
>-  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
>+  BUILD_BUG_OR_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
> 
> #define inline		inline		__attribute__((always_inline))
> #define __inline__	__inline__	__attribute__((always_inline))
>diff -r 6fb745a5bb51 include/linux/kernel.h
>--- a/include/linux/kernel.h	Mon Mar 12 09:12:20 2007 +1100
>+++ b/include/linux/kernel.h	Mon Mar 12 09:51:25 2007 +1100
>@@ -341,7 +341,7 @@ struct sysinfo {
>    result (of value 0 and type size_t), so the expression can be used
>    e.g. in a structure initializer (or where-ever else comma expressions
>    aren't permitted). */
>-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>+#define BUILD_BUG_OR_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
> 
> /* Trap pasters of __FUNCTION__ at compile-time */
> #define __FUNCTION__ (__func__)
>diff -r 6fb745a5bb51 include/linux/moduleparam.h
>--- a/include/linux/moduleparam.h	Mon Mar 12 09:12:20 2007 +1100
>+++ b/include/linux/moduleparam.h	Mon Mar 12 09:51:42 2007 +1100
>@@ -65,7 +65,7 @@ struct kparam_array
> #define __module_param_call(prefix, name, set, get, arg, perm)		\
> 	/* Default value instead of permissions? */			\
> 	static int __param_perm_check_##name __attribute__((unused)) =	\
>-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
>+	BUILD_BUG_OR_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
> 	static char __param_str_##name[] = prefix #name;		\
> 	static struct kernel_param const __param_##name			\
> 	__attribute_used__						\
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

Jan
-- 
