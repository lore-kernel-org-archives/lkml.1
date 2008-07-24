Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYGXOuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYGXOuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYGXOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:43:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:48697 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbYGXOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=Da5LepGYR/N8338gWg1GT0JvaeuHpIzgEp3n4xOmu1tGJjg2h9m1SmTb4n4fiddenn
         jh7j8Wcdndd3Rw+nqR86QD/FkPd5ryDG9+kSHRR48x2+eGNGi27PSTykodXN372TBG/4
         ut7AM9Hy/gUkR5xdOsV9dkQPbmiU18hkIhjt8=
Date: Thu, 24 Jul 2008 15:41:48 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au
Subject: [Patch] kernel/module.c: fix a build warning
Message-ID: <20080724144148.GM2993@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixed the warning:

  CC      kernel/module.o
  /home/wangcong/Projects/linux-2.6/kernel/module.c:332: warning:
‘lookup_symbol’ defined but not used


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: rusty@rustcorp.com.au

---
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
