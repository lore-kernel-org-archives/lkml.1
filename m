Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbYAQVqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbYAQVqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYAQVln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:43 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44794 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbYAQVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:38 -0500
Date: Thu, 17 Jan 2008 16:40:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/20] UML - Add back CONFIG_HZ
Message-ID: <20080117214041.GA6717@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avoid-overflows-in-kernel-timec.patch makes CONFIG_HZ necessary for a
successful build.  UML lacks a definition, so this patch adds one.  It
also changes the hard-wired definition of HZ to CONFIG_HZ.

Note: this patch is a good idea even in the absence of hpa's time
fixes.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig        |    4 ++++
 include/asm-um/param.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/um/Kconfig	2008-01-01 17:32:04.000000000 -0500
+++ linux-2.6.22/arch/um/Kconfig	2008-01-02 11:16:44.000000000 -0500
@@ -68,6 +68,10 @@ config IRQ_RELEASE_METHOD
 	bool
 	default y
 
+config HZ
+	int
+	default 100
+
 menu "UML-specific options"
 
 config STATIC_LINK
Index: linux-2.6.22/include/asm-um/param.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/param.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/param.h	2008-01-02 11:18:44.000000000 -0500
@@ -10,7 +10,7 @@
 #define MAXHOSTNAMELEN  64      /* max length of hostname */
 
 #ifdef __KERNEL__
-#define HZ 100
+#define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
 #endif
