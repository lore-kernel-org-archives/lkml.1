Return-Path: <linux-kernel-owner+w=401wt.eu-S937750AbYBWIgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937750AbYBWIgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936939AbYBWIVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:24 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936045AbYBWIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g6xAKmTi3Zo8UM2MLDI6nFu3G/lbruJUTGdaDodQBcIzITpEz+vgfuehO/d5WRGXQD2dP/GgwMkmUkGZnKSARgrZDUSu2S+ksTCjgo/s3vUeJIaJ+5azUROSfvgrRTVwoJwmSahTFqliHGkqKrR1LDsuoVOx7EAFw71+SKGOLME=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH 12/16] ia64: use get_personality()
Date: Sat, 23 Feb 2008 16:14:15 +0800
Message-Id: <1203754579637-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754571655-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
 <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
 <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
 <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
 <1203754571655-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for ia64 code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

---
 arch/ia64/ia32/sys_ia32.c |    2 +-
 arch/ia64/mm/init.c       |    2 +-
 include/asm-ia64/fcntl.h  |    2 +-
 include/asm-ia64/namei.h  |    2 +-
 include/asm-ia64/page.h   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index d025a22..a91273f 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -2265,7 +2265,7 @@ sys32_personality (unsigned int personality)
 {
 	long ret;
 
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
+	if (get_personality() == PER_LINUX32 && personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
 	if (ret == PER_LINUX32)
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 25aef62..f5641bb 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -139,7 +139,7 @@ ia64_init_addr_space (void)
 	}
 
 	/* map NaT-page at address zero to speed up speculative dereferencing of NULL: */
-	if (!(current->personality & MMAP_PAGE_ZERO)) {
+	if (!(get_personality() & MMAP_PAGE_ZERO)) {
 		vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 		if (vma) {
 			vma->vm_mm = current->mm;
diff --git a/include/asm-ia64/fcntl.h b/include/asm-ia64/fcntl.h
index 1dd275d..e8acf85 100644
--- a/include/asm-ia64/fcntl.h
+++ b/include/asm-ia64/fcntl.h
@@ -6,7 +6,7 @@
  */
 
 #define force_o_largefile()	\
-		(personality(current->personality) != PER_LINUX32)
+		(personality(get_personality()) != PER_LINUX32)
 
 #include <asm-generic/fcntl.h>
 
diff --git a/include/asm-ia64/namei.h b/include/asm-ia64/namei.h
index 78e7680..da38e5c 100644
--- a/include/asm-ia64/namei.h
+++ b/include/asm-ia64/namei.h
@@ -14,7 +14,7 @@
 static inline char *
 __emul_prefix (void)
 {
-	switch (current->personality) {
+	switch (get_personality()) {
 	      case PER_LINUX32:
 		return EMUL_PREFIX_LINUX_IA32;
 	      default:
diff --git a/include/asm-ia64/page.h b/include/asm-ia64/page.h
index 4999a6c..287e53b 100644
--- a/include/asm-ia64/page.h
+++ b/include/asm-ia64/page.h
@@ -224,7 +224,7 @@ get_order (unsigned long size)
 
 #define VM_DATA_DEFAULT_FLAGS		(VM_READ | VM_WRITE |					\
 					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |		\
-					 (((current->personality & READ_IMPLIES_EXEC) != 0)	\
+					 (((get_personality() & READ_IMPLIES_EXEC) != 0)	\
 					  ? VM_EXEC : 0))
 
 #endif /* _ASM_IA64_PAGE_H */
-- 
1.5.3.8

