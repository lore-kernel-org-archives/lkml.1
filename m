Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbYBOOMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbYBOOMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbYBOOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:11:52 -0500
Received: from ag-out-0708.google.com ([72.14.246.249]:56757 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437AbYBOOLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=dASo5Z3srcaKHoAnqKsZHalbx23SHHaJXXWYCPnDljFQs9NYFULsKN20FuadCTM5uL6ff/2cATOFOfMvzfSpG1iYCmE4QI0GWdW8Nv7s4s1GDJa0SsPnCHR1rnq04GB7YiYS70MCvPGoS2IWoMF/GgtyyWJzmPacc01ZZx39upQ=
Date: Fri, 15 Feb 2008 22:07:42 +0800 (CST)
Message-Id: <20080215.220742.106815696.xiyou.wangcong@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, dike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] arch/um/kernel/um_arch.c: some small improvements
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make some small improvements for arch/um/kernel/um_arch.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index a6c1dd1..56deed6 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -115,7 +115,7 @@ static int have_root __initdata = 0;
 /* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
-static char *usage_string =
+static const char *usage_string =
 "User Mode Linux v%s\n"
 "	available at http://user-mode-linux.sourceforge.net/\n\n";
 
@@ -202,7 +202,7 @@ static void __init uml_checksetup(char *line, int *add)
 
 	p = &__uml_setup_start;
 	while (p < &__uml_setup_end) {
-		int n;
+		size_t n;
 
 		n = strlen(p->str);
 		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
@@ -258,7 +258,8 @@ int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
-	unsigned int i, add;
+	unsigned int i;
+	int add;
 	char * mode;
 
 	for (i = 1; i < argc; i++) {
