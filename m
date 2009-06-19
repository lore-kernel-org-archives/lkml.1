Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZFSHtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZFSHtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSHtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:49:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37775 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbZFSHtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:49:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
Subject: [PATCH] module: use MODULE_SYMBOL_PREFIX with module_layout
Date: Fri, 19 Jun 2009 03:49:22 -0400
Message-Id: <1245397762-13172-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <200906191508.06537.rusty@rustcorp.com.au>
References: <200906191508.06537.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check_modstruct_version() needs to look up the symbol "module_layout"
in the kernel, but it does so literally and not by a C identifier.  The
trouble is that it does not include a symbol prefix for those ports that
need it (like the Blackfin and H8300 port).  So make sure we tack on the
MODULE_SYMBOL_PREFIX define to the front of it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/module.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 80036bc..7850bef 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1053,7 +1053,8 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 {
 	const unsigned long *crc;
 
-	if (!find_symbol("module_layout", NULL, &crc, true, false))
+	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
+	                 &crc, true, false))
 		BUG();
 	return check_version(sechdrs, versindex, "module_layout", mod, crc);
 }
-- 
1.6.3.1

