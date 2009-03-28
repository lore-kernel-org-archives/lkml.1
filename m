Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZC1NY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZC1NY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZC1NXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:23:50 -0400
Received: from ozlabs.org ([203.10.76.45]:52791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZC1NXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:23:49 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 28 Mar 2009 23:53:44 +1030
Subject: [PATCH 3/5] module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282353.45114.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: new API

__builtin_types_compatible_p() is a little awkward to use: it takes two
types rather than types or variables, and it's just damn long.

(typeof(type) == type, so this works on types as well as vars).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -260,6 +260,11 @@ void ftrace_likely_update(struct ftrace_
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+/* Are two types/vars the same type (ignoring qualifiers)? */
+#ifndef __same_type
+# define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
+#endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),

