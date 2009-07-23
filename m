Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZGWOMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZGWOMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZGWOMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:12:18 -0400
Received: from ozlabs.org ([203.10.76.45]:54305 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZGWOMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:12:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: use MODULE_SYMBOL_PREFIX with module_layout
Date: Thu, 23 Jul 2009 23:42:08 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232342.08817.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The check_modstruct_version() needs to look up the symbol "module_layout"
in the kernel, but it does so literally and not by a C identifier.  The
trouble is that it does not include a symbol prefix for those ports that
need it (like the Blackfin and H8300 port).  So make sure we tack on the
MODULE_SYMBOL_PREFIX define to the front of it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1068,7 +1068,8 @@ static inline int check_modstruct_versio
 {
 	const unsigned long *crc;
 
-	if (!find_symbol("module_layout", NULL, &crc, true, false))
+	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
+			 &crc, true, false))
 		BUG();
 	return check_version(sechdrs, versindex, "module_layout", mod, crc);
 }
