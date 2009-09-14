Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbZINUVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbZINUVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933505AbZINUVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:21:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54034 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399AbZINUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 19/72] Blackfin: convert malloc()/memset() to zalloc() in module code
Date: Mon, 14 Sep 2009 16:07:23 -0400
Message-Id: <1252958896-25150-20-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/module.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index b8f4c67..50d7fbf 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -98,14 +98,13 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 		if (strcmp(".l1.bss", secstrings + s->sh_name) == 0 ||
 		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
 		     (hdr->e_flags & EF_BFIN_DATA_IN_L1) && (s->sh_size > 0))) {
-			dest = l1_data_sram_alloc(s->sh_size);
+			dest = l1_data_sram_zalloc(s->sh_size);
 			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
 				pr_err("L1 data memory allocation failed\n",
 					mod->name);
 				return -1;
 			}
-			memset(dest, 0, s->sh_size);
 			s->sh_flags &= ~SHF_ALLOC;
 			s->sh_addr = (unsigned long)dest;
 		}
@@ -164,14 +163,13 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 		if (strcmp(".l2.bss", secstrings + s->sh_name) == 0 ||
 		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
 		     (hdr->e_flags & EF_BFIN_DATA_IN_L2) && (s->sh_size > 0))) {
-			dest = l2_sram_alloc(s->sh_size);
+			dest = l2_sram_zalloc(s->sh_size);
 			mod->arch.bss_l2 = dest;
 			if (dest == NULL) {
 				pr_err("L2 SRAM allocation failed\n",
 					mod->name);
 				return -1;
 			}
-			memset(dest, 0, s->sh_size);
 			s->sh_flags &= ~SHF_ALLOC;
 			s->sh_addr = (unsigned long)dest;
 		}
-- 
1.6.4.2

