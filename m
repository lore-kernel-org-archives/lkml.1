Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbYHEUUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbYHEUUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbYHEUOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48099 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbYHEUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:45 -0400
Date: Tue, 5 Aug 2008 16:14:09 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 9/14] uml: memcpy export needs to follow host declaration
Message-ID: <20080805201409.GA11792@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8bfd04b974689f700bbd053ad6e66b0a95fb80c9

x86_64 defines either memcpy or __memcpy depending on the gcc version, and
it looks like UML needs to follow that in its exporting.

Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/sys-x86_64/ksyms.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/um/sys-x86_64/ksyms.c b/arch/um/sys-x86_64/ksyms.c
index 08f63e2..467879a 100644
--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -13,5 +13,9 @@ EXPORT_SYMBOL(__down_failed_trylock);
 EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
 EXPORT_SYMBOL(csum_partial);
-- 
1.5.5.1

