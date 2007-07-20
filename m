Return-Path: <linux-kernel-owner+w=401wt.eu-S937017AbXGTBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937017AbXGTBB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbXGTBBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:01:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXGTBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:01:19 -0400
Date: Fri, 20 Jul 2007 02:01:16 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@addtoit.com, sam@ravnborg.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fallout from kbuild changes
Message-ID: <20070720010116.GB21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Change in 'kbuild: do section mismatch check on full vmlinux'
should've been replicated in arch/um/Makefile.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 5d5ed72..989224f 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -146,7 +146,7 @@ define cmd_vmlinux__
 	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
 	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
 	-lutil \
-	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) \
+	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
 	FORCE ,$^) ; rm -f linux
 endef
 
