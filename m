Return-Path: <linux-kernel-owner+w=401wt.eu-S2992978AbXCIF5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992978AbXCIF5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992988AbXCIF5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:57:30 -0500
Received: from ozlabs.org ([203.10.76.45]:54137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992978AbXCIF53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:57:29 -0500
Subject: [PATCH] Use more gcc extensions in the Linux headers
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 16:56:32 +1100
Message-Id: <1173419792.32234.131.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__builtin_types_compatible_p() has been around since gcc 2.95, and we
don't use it anywhere.  This patch quietly fixes that.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f0ff8138f993 include/linux/kernel.h
--- a/include/linux/kernel.h	Fri Mar 09 16:40:25 2007 +1100
+++ b/include/linux/kernel.h	Fri Mar 09 16:44:04 2007 +1100
@@ -35,7 +35,9 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
+	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
+		 typeof(&arr[0]))]))*0)
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))


