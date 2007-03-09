Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXCIW6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXCIW6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767594AbXCIW6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:58:31 -0500
Received: from ozlabs.org ([203.10.76.45]:36062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416AbXCIW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:58:30 -0500
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
References: <1173419792.32234.131.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 09:57:32 +1100
Message-Id: <1173481052.32234.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 16:56 +1100, Rusty Russell wrote:
> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.

OK, many people complained that it needed a comment.  Good point!
==
Add comment to ARRAY_SIZE macro.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 933e410f204f include/linux/kernel.h
--- a/include/linux/kernel.h	Sat Mar 10 09:55:31 2007 +1100
+++ b/include/linux/kernel.h	Sat Mar 10 09:55:53 2007 +1100
@@ -35,6 +35,7 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
+/* GCC is awesome. */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
 	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
 		 typeof(&arr[0]))]))*0)



