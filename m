Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYA3UJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYA3UJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759771AbYA3UCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:39 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51793 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761355AbYA3UCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:36 -0500
Date: Wed, 30 Jan 2008 22:03:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] powerpc: vdso_do_func_patch{32,64}() must be __init
Message-ID: <20080130200310.GF29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0xe49c): Section mismatch in reference from the function .vdso_do_func_patch64() to the function .init.text:.find_symbol64()
WARNING: vmlinux.o(.text+0xe4d0): Section mismatch in reference from the function .vdso_do_func_patch64() to the function .init.text:.find_symbol64()
WARNING: vmlinux.o(.text+0xe56c): Section mismatch in reference from the function .vdso_do_func_patch32() to the function .init.text:.find_symbol32()
WARNING: vmlinux.o(.text+0xe5a0): Section mismatch in reference from the function .vdso_do_func_patch32() to the function .init.text:.find_symbol32()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/powerpc/kernel/vdso.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

1c52ed2049b82e8458d03e50633b01ac5e1dfa40 
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 3702df7..d3437c4 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -336,9 +336,9 @@ static unsigned long __init find_function32(struct lib32_elfinfo *lib,
 	return sym->st_value - VDSO32_LBASE;
 }
 
-static int vdso_do_func_patch32(struct lib32_elfinfo *v32,
-				struct lib64_elfinfo *v64,
-				const char *orig, const char *fix)
+static int __init vdso_do_func_patch32(struct lib32_elfinfo *v32,
+				       struct lib64_elfinfo *v64,
+				       const char *orig, const char *fix)
 {
 	Elf32_Sym *sym32_gen, *sym32_fix;
 
@@ -433,9 +433,9 @@ static unsigned long __init find_function64(struct lib64_elfinfo *lib,
 #endif
 }
 
-static int vdso_do_func_patch64(struct lib32_elfinfo *v32,
-				struct lib64_elfinfo *v64,
-				const char *orig, const char *fix)
+static int __init vdso_do_func_patch64(struct lib32_elfinfo *v32,
+				       struct lib64_elfinfo *v64,
+				       const char *orig, const char *fix)
 {
 	Elf64_Sym *sym64_gen, *sym64_fix;
 

