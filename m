Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYFCTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYFCTEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFCTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:04:05 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58518 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbYFCTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:04:03 -0400
Date: Tue, 3 Jun 2008 15:02:37 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH 4/6] UML - memcpy export needs to follow host declaration
Message-ID: <20080603190237.GA9517@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 defines either memcpy or __memcpy depending on the gcc version,
and it looks like UML needs to follow that in its exporting.

Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-x86_64/ksyms.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-git/arch/um/sys-x86_64/ksyms.c
===================================================================
--- linux-2.6-git.orig/arch/um/sys-x86_64/ksyms.c	2008-05-28 12:32:34.000000000 -0400
+++ linux-2.6-git/arch/um/sys-x86_64/ksyms.c	2008-06-02 15:49:43.000000000 -0400
@@ -3,5 +3,9 @@
 #include <asm/checksum.h>
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
 EXPORT_SYMBOL(csum_partial);
