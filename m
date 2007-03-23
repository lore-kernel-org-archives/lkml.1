Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXCWSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXCWSWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXCWSWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:22:55 -0400
Received: from [198.99.130.12] ([198.99.130.12]:58590 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbXCWSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:22:54 -0400
Date: Fri, 23 Mar 2007 14:18:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - fix epoll
Message-ID: <20070323181817.GA8694@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is both 2.6.21 and -stable material ]

UML/x86_64 needs the same packing of struct epoll_event as x86_64.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/linux/eventpoll.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.21-mm/include/linux/eventpoll.h
===================================================================
--- linux-2.6.21-mm.orig/include/linux/eventpoll.h	2007-03-05 13:01:17.000000000 -0500
+++ linux-2.6.21-mm/include/linux/eventpoll.h	2007-03-23 14:03:07.000000000 -0400
@@ -31,12 +31,19 @@
 /* 
  * On x86-64 make the 64bit structure have the same alignment as the
  * 32bit structure. This makes 32bit emulation easier.
+ *
+ * UML/x86_64 needs the same packing as x86_64 - UML + UML_X86 +
+ * 64_BIT adds up to UML/x86_64.
  */
 #ifdef __x86_64__
 #define EPOLL_PACKED __attribute__((packed))
 #else
+#if defined(CONFIG_UML) && defined(CONFIG_UML_X86) && defined(CONFIG_64BIT)
+#define EPOLL_PACKED __attribute__((packed))
+#else
 #define EPOLL_PACKED
 #endif
+#endif
 
 struct epoll_event {
 	__u32 events;
