Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZBGMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZBGMr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZBGMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:45 -0500
Received: from ozlabs.org ([203.10.76.45]:45015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbZBGMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:43 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 5/9] module: use strstarts()
Message-Id: <20090207124642.21579DDDE0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: minor cleanup.

I'm not going to neaten anyone else's code, but I'm happy to clean up
my own.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1643,8 +1643,7 @@ static void layout_sections(struct modul
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strncmp(secstrings + s->sh_name,
-				       ".init", 5) == 0)
+			    || strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
@@ -1661,8 +1660,7 @@ static void layout_sections(struct modul
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strncmp(secstrings + s->sh_name,
-				       ".init", 5) != 0)
+			    || strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
@@ -1795,8 +1793,7 @@ static char elf_type(const Elf_Sym *sym,
 		else
 			return 'b';
 	}
-	if (strncmp(secstrings + sechdrs[sym->st_shndx].sh_name,
-		    ".debug", strlen(".debug")) == 0)
+	if (strstarts(secstrings + sechdrs[sym->st_shndx].sh_name, ".debug"))
 		return 'n';
 	return '?';
 }
@@ -1935,7 +1932,7 @@ static noinline struct module *load_modu
 		}
 #ifndef CONFIG_MODULE_UNLOAD
 		/* Don't load .exit sections */
-		if (strncmp(secstrings+sechdrs[i].sh_name, ".exit", 5) == 0)
+		if (strstarts(secstrings+sechdrs[i].sh_name, ".exit"))
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
 	}

