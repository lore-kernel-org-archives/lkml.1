Return-Path: <linux-kernel-owner+w=401wt.eu-S937125AbYBWIa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937125AbYBWIa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936861AbYBWIT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:19:58 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:35865 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936851AbYBWIT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iH2HTQtEt6cX71giOagMLmFKGPvHqVEQViOwPb/uP2Lg6pd5qrZx6Uu5KnhWTJfULXDdVQtplfW8R3pFPQpP6i28oKo91lo5kbjSyYYCdkrZOkcR+yEuGnQTDtJzADHISwvnsi6Bs17VYNw0QG/H0qHZ0D63vxGtIz8HLSpl1Y0=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 04/16] powerpc: use get_personality()
Date: Sat, 23 Feb 2008 16:14:07 +0800
Message-Id: <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for powerpc code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>

---
 arch/powerpc/kernel/syscalls.c |    4 ++--
 arch/powerpc/mm/mmap.c         |    2 +-
 include/asm-powerpc/elf.h      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index 3b1d5dd..4b910b8 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -228,7 +228,7 @@ long ppc64_personality(unsigned long personality)
 {
 	long ret;
 
-	if (personality(current->personality) == PER_LINUX32
+	if (personality(get_personality()) == PER_LINUX32
 	    && personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
@@ -239,7 +239,7 @@ long ppc64_personality(unsigned long personality)
 #endif
 
 #ifdef CONFIG_PPC64
-#define OVERRIDE_MACHINE    (personality(current->personality) == PER_LINUX32)
+#define OVERRIDE_MACHINE    (personality(get_personality()) == PER_LINUX32)
 #else
 #define OVERRIDE_MACHINE    0
 #endif
diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
index 86010fc..92a9e45 100644
--- a/arch/powerpc/mm/mmap.c
+++ b/arch/powerpc/mm/mmap.c
@@ -54,7 +54,7 @@ static inline int mmap_is_legacy(void)
 	if (!test_thread_flag(TIF_32BIT))
 		return 1;
 
-	if (current->personality & ADDR_COMPAT_LAYOUT)
+	if (get_personality() & ADDR_COMPAT_LAYOUT)
 		return 1;
 
 	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index 9080d85..d9e7bff 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -256,7 +256,7 @@ do {								\
 		set_thread_flag(TIF_ABI_PENDING);		\
 	else							\
 		clear_thread_flag(TIF_ABI_PENDING);		\
-	if (personality(current->personality) != PER_LINUX32)	\
+	if (personality(get_personality()) != PER_LINUX32)	\
 		set_personality(PER_LINUX);			\
 } while (0)
 /*
-- 
1.5.3.8

