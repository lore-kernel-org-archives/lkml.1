Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbYDXP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbYDXP3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbYDXPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:18:46 -0400
Received: from ozlabs.org ([203.10.76.45]:51865 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761514AbYDXPSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:18:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Fix non-kernel use of include/linux/types.h
Date: Fri, 25 Apr 2008 01:14:38 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804250114.38971.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from ../../include/linux/if_tun.h:21,
                 from lguest.c:30:
../../include/linux/types.h:203: error: expected specifier-qualifier-list before ‘__kernel_daddr_t’

This reversion was created by e40c0fe6b0b5dd16aec3c0dad311d36b19d78fd9
'x86: cleanup duplicate includes' which removed the !__KERNEL__ case from
asm-x86/posix_types.h.

CC: Joe Perches <joe@perches.com>
---
 include/asm-x86/posix_types.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -r c06e2499a606 include/asm-x86/posix_types.h
--- a/include/asm-x86/posix_types.h	Tue Apr 22 07:59:24 2008 +1000
+++ b/include/asm-x86/posix_types.h	Tue Apr 22 08:59:18 2008 +1000
@@ -1,7 +1,5 @@
-#ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
+#if defined(CONFIG_X86_32) || defined(__i386__)
+# include "posix_types_32.h"
+#else
+# include "posix_types_64.h"
 #endif
