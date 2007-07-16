Return-Path: <linux-kernel-owner+w=401wt.eu-S1765423AbXGPN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765423AbXGPN2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXGPN2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:28:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45343 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbXGPN2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:28:32 -0400
Date: Mon, 16 Jul 2007 17:27:29 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 2/2] Make unregister_binfmt() return void
Message-ID: <20070716132729.GB11126@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

list_del() hardly can fail, so checking for return value is pointless
(and current code always return 0).

Nobody really cared that return value anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/ia64/ia32/binfmt_elf32.c |    2 +-
 fs/exec.c                     |    3 +--
 include/linux/binfmts.h       |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/ia64/ia32/binfmt_elf32.c
+++ b/arch/ia64/ia32/binfmt_elf32.c
@@ -275,7 +275,7 @@ static int __init check_elf32_binfmt(void)
 {
 	if (cpu_uses_ia32el()) {
 		printk("Please use IA-32 EL for executing IA-32 binaries\n");
-		return unregister_binfmt(&elf_format);
+		unregister_binfmt(&elf_format);
 	}
 	return 0;
 }
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -81,12 +81,11 @@ int register_binfmt(struct linux_binfmt * fmt)
 
 EXPORT_SYMBOL(register_binfmt);
 
-int unregister_binfmt(struct linux_binfmt * fmt)
+void unregister_binfmt(struct linux_binfmt * fmt)
 {
 	write_lock(&binfmt_lock);
 	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
-	return 0;
 }
 
 EXPORT_SYMBOL(unregister_binfmt);
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -65,7 +65,7 @@ struct linux_binfmt {
 };
 
 extern int register_binfmt(struct linux_binfmt *);
-extern int unregister_binfmt(struct linux_binfmt *);
+extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int prepare_binprm(struct linux_binprm *);
 extern void remove_arg_zero(struct linux_binprm *);

