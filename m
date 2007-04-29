Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbXD2LE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbXD2LE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXD2LBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:51226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbXD2Kw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/48] x86_64: Allow sys_uselib unconditionally
Message-Id: <20070429105252.E7549151EA@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Previously it wasn't enabled in the binfmt_aout is a module case. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/ia32entry.S |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -481,11 +481,7 @@ ia32_sys_call_table:
 	.quad sys_symlink
 	.quad sys_lstat
 	.quad sys_readlink		/* 85 */
-#ifdef CONFIG_IA32_AOUT
 	.quad sys_uselib
-#else
-	.quad quiet_ni_syscall
-#endif
 	.quad sys_swapon
 	.quad sys_reboot
 	.quad compat_sys_old_readdir
