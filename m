Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZIYP6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZIYP6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZIYP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:58:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZIYP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=rmt1OtmDQX2pwc/zkr6zc6pBue4T1tyiP295vVvQZf6753Po1rXP+ePEcLHTyclY9y
         4bqW1hvnCjx4/sVtJWrrPA4TXWC51Gq9XCNq3L0UsgQw55hbateUupmqbg1PBo4V2MHp
         4itKSznuOXll23ZAnOOowH5GmlZeCzxOsLyEw=
From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?= 
	<flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build with KALLSYMS disabled.
Date: Fri, 25 Sep 2009 17:58:32 +0200
Message-Id: <1253894312-17663-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With KALLSYMS disabled, but some debug features enabled, build will fail
because the layout_symtab function uses the wrong type for ELF headers, and
some variables are not declared. Fix that.

Signed-off-by: Diego Elio 'Flameeyes' Pettenò <flameeyes@gmail.com>
---
 kernel/module.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5a29397..8dc6017 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1992,7 +1992,7 @@ static inline unsigned long layout_symtab(struct module *mod,
 					  Elf_Shdr *sechdrs,
 					  unsigned int symindex,
 					  unsigned int strindex,
-					  const Elf_Hdr *hdr,
+					  const Elf_Ehdr *hdr,
 					  const char *secstrings,
 					  unsigned long *pstroffs,
 					  unsigned long *strmap)
@@ -2081,9 +2081,7 @@ static noinline struct module *load_module(void __user *umod,
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-#ifdef CONFIG_KALLSYMS
 	unsigned long symoffs, stroffs, *strmap;
-#endif
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
-- 
1.6.5.rc1

