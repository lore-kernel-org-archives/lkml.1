Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYEHNzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYEHNzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYEHNyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:54:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:65466 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYEHNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GNLIX0pKX2mxENGWcSUK4AIzfP/Htbbp8pyBR/tdw7ePpb4gNMbXKIpISad/skYt5hRFq3qU5oVLdEWqMDCjrVjWylg0PTVFZSVAqsbmKm583GulXvtfmz9TOMlpFOw6+Db14x30kFt8X4i5ROfrBWrneGpNa8S5MPLmbyKU8CM=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 1/9] fs/exec.c: export free_arg_pages
Date: Thu,  8 May 2008 21:52:26 +0800
Message-Id: <12102547782640-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_arg_pages() is used to clean the pages allocated by copy_strings_kenrel().
Since copy_strings_kernel() is exported, so should be free_arg_pages().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b512e48..a2bfa57 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -96,6 +96,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
+extern void free_arg_pages(struct linux_binprm *bprm);
 extern void compute_creds(struct linux_binprm *binprm);
 extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
diff --git a/fs/exec.c b/fs/exec.c
index aeaa979..b49ba41 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -210,7 +210,7 @@ static void free_arg_page(struct linux_binprm *bprm, int i)
 {
 }
 
-static void free_arg_pages(struct linux_binprm *bprm)
+void free_arg_pages(struct linux_binprm *bprm)
 {
 }
 
@@ -301,7 +301,7 @@ static void free_arg_page(struct linux_binprm *bprm, int i)
 	}
 }
 
-static void free_arg_pages(struct linux_binprm *bprm)
+void free_arg_pages(struct linux_binprm *bprm)
 {
 	int i;
 
@@ -327,6 +327,8 @@ static bool valid_arg_len(struct linux_binprm *bprm, long len)
 
 #endif /* CONFIG_MMU */
 
+EXPORT_SYMBOL(free_arg_pages);
+
 /*
  * Create a new mm_struct and populate it with a temporary stack
  * vm_area_struct.  We don't have enough context at this point to set the stack
