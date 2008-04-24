Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYDXFC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYDXFC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYDXFBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:01:30 -0400
Received: from ozlabs.org ([203.10.76.45]:37185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbYDXFB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:01:29 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 24 Apr 2008 00:01:24 -0500
Subject: [PATCH 4/6] module: set unused_gpl_crcs instead of overwriting unused_crcs
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241501.24940.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Obvious typo, but I don't know of any modules with unused GPL exports,
and then it would take someone noticing that the version shouldn't
have matched in a dependent module.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -r 257476cdfb79 kernel/module.c
--- a/kernel/module.c	Thu Apr 10 15:15:17 2008 +1000
+++ b/kernel/module.c	Thu Apr 10 15:17:08 2008 +1000
@@ -1997,7 +1997,8 @@ static struct module *load_module(void _
 		mod->unused_crcs = (void *)sechdrs[unusedcrcindex].sh_addr;
 	mod->unused_gpl_syms = (void *)sechdrs[unusedgplindex].sh_addr;
 	if (unusedgplcrcindex)
-		mod->unused_crcs = (void *)sechdrs[unusedgplcrcindex].sh_addr;
+		mod->unused_gpl_crcs
+			= (void *)sechdrs[unusedgplcrcindex].sh_addr;
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !crcindex) ||

