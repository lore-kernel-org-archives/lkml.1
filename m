Return-Path: <linux-kernel-owner+w=401wt.eu-S933953AbXHYJy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbXHYJy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbXHYJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:54:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:65056 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763705AbXHYJys (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=OpjAd9dzr30MKgNgN7RPWy5PbHRh/OZyuYooqbhgbNcJC52xXJny4QgKTZb6CbCQdBtzKVEsFnRE7KKDNP2ercK5yJ4RBxDlMAEbwr+GnIYJSRpxR8pKPSgEPa5IaBaf2aKxmBc9UmOet4sdXsciHFUiZQn5Vjky0wR7t0LDPAI=
From: Denis Cheng <crquan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux-Kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] [arch/i386/boot]: for better readability in clearing BSS
Date: Sat, 25 Aug 2007 17:54:32 +0800
Message-Id: <11880356722224-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

there are three different linker scripts with different usages,

	arch/i386/boot/setup.ld
	arch/i386/boot/compressed/vmlinux.lds
	arch/i386/kernel/vmlinux.lds

accompanlying with three different sections of clearing BSS,

	arch/i386/boot/header.S
	arch/i386/boot/compressed/head.S
	arch/i386/kernel/head.S

but their label names in .bss section are different,
when reading these files, they are apt to confuse,

this patch kept them in the same style of clearing.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 arch/i386/boot/compressed/head.S |    2 +-
 arch/i386/boot/header.S          |    2 +-
 arch/i386/boot/setup.ld          |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/i386/boot/compressed/head.S b/arch/i386/boot/compressed/head.S
index f35ea22..e499db0 100644
--- a/arch/i386/boot/compressed/head.S
+++ b/arch/i386/boot/compressed/head.S
@@ -113,7 +113,7 @@ relocated:
  * Clear BSS
  */
 	xorl %eax,%eax
-	leal _edata(%ebx),%edi
+	leal _bss(%ebx),%edi
 	leal _end(%ebx), %ecx
 	subl %edi,%ecx
 	cld
diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
index 7f4a2c5..cd074c1 100644
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -254,7 +254,7 @@ setup2:
 
 # Zero the bss
 	movw	$__bss_start, %di
-	movw	$_end+3, %cx
+	movw	$__bss_end, %cx
 	xorl	%eax, %eax
 	subw	%di, %cx
 	shrw	$2, %cx
diff --git a/arch/i386/boot/setup.ld b/arch/i386/boot/setup.ld
index df9234b..f9d6897 100644
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -36,15 +36,15 @@ SECTIONS
 		LONG(0x5a5aaa55)
 	}
 
-
 	. = ALIGN(16);
 	.bss		:
 	{
 		__bss_start = .;
 		*(.bss)
+		. = ALIGN(16);
 		__bss_end = .;
 	}
-	. = ALIGN(16);
+
 	_end = .;
 
 	/DISCARD/ : { *(.note*) }
-- 
1.5.3.rc4

