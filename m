Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYGYCjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYGYCjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYGYCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:39:17 -0400
Received: from ozlabs.org ([203.10.76.45]:49588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYGYCjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:39:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: fix build warning with !CONFIG_KALLSYMS
Date: Fri, 25 Jul 2008 12:39:14 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807251239.14337.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 24 Jul 2008 15:41:48 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch fixed the warning:

  CC      kernel/module.o
  /home/wangcong/Projects/linux-2.6/kernel/module.c:332: warning:
‘lookup_symbol’ defined but not used

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d8b5605..d861bd5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -325,18 +325,6 @@ static unsigned long find_symbol(const char *name,
 	return -ENOENT;
 }
 
-/* lookup symbol in given range of kernel_symbols */
-static const struct kernel_symbol *lookup_symbol(const char *name,
-	const struct kernel_symbol *start,
-	const struct kernel_symbol *stop)
-{
-	const struct kernel_symbol *ks = start;
-	for (; ks < stop; ks++)
-		if (strcmp(ks->name, name) == 0)
-			return ks;
-	return NULL;
-}
-
 /* Search for module by name: must hold module_mutex. */
 static struct module *find_module(const char *name)
 {
@@ -1703,6 +1691,19 @@ static void setup_modinfo(struct module *mod, Elf_Shdr *sechdrs,
 }
 
 #ifdef CONFIG_KALLSYMS
+
+/* lookup symbol in given range of kernel_symbols */
+static const struct kernel_symbol *lookup_symbol(const char *name,
+	const struct kernel_symbol *start,
+	const struct kernel_symbol *stop)
+{
+	const struct kernel_symbol *ks = start;
+	for (; ks < stop; ks++)
+		if (strcmp(ks->name, name) == 0)
+			return ks;
+	return NULL;
+}
+
 static int is_exported(const char *name, const struct module *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))

