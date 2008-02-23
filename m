Return-Path: <linux-kernel-owner+w=401wt.eu-S937798AbYBWIgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937798AbYBWIgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936424AbYBWIVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:33 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936404AbYBWIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OwMoM0ZOnmNEgKVusMADPFaaTvxE59QukiENbZl+CaEbSRHTbOCzu3zLPX/8mMSARICJPlDbAO+J1Vi7AicNyURiIO/dAAMrpDi2h5dVVCokwMc82L3aOnGHdG0c3L0iD7zUYSip4eEY5U1Dz1i6u2yXPvbhfW6fuPzc+0ThGu0=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH 13/16] alpha: use get_personality()
Date: Sat, 23 Feb 2008 16:14:16 +0800
Message-Id: <1203754594597-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754579637-git-send-email-xiyou.wangcong@gmail.com>
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
 <1203754579637-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for alpha code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>

---
 arch/alpha/kernel/osf_sys.c   |    6 +++---
 include/asm-alpha/processor.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 8c71daf..df825a4 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1266,7 +1266,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	unsigned long limit;
 
 	/* "32 bit" actually means 31 bit, since pointers sign extend.  */
-	if (current->personality & ADDR_LIMIT_32BIT)
+	if (get_personality() & ADDR_LIMIT_32BIT)
 		limit = 0x80000000;
 	else
 		limit = TASK_SIZE;
@@ -1327,7 +1327,7 @@ osf_fix_iov_len(const struct iovec __user *iov, unsigned long count)
 asmlinkage ssize_t
 osf_readv(unsigned long fd, const struct iovec __user * vector, unsigned long count)
 {
-	if (unlikely(personality(current->personality) == PER_OSF4))
+	if (unlikely(personality(get_personality()) == PER_OSF4))
 		if (osf_fix_iov_len(vector, count))
 			return -EFAULT;
 	return sys_readv(fd, vector, count);
@@ -1336,7 +1336,7 @@ osf_readv(unsigned long fd, const struct iovec __user * vector, unsigned long co
 asmlinkage ssize_t
 osf_writev(unsigned long fd, const struct iovec __user * vector, unsigned long count)
 {
-	if (unlikely(personality(current->personality) == PER_OSF4))
+	if (unlikely(personality(get_personality()) == PER_OSF4))
 		if (osf_fix_iov_len(vector, count))
 			return -EFAULT;
 	return sys_writev(fd, vector, count);
diff --git a/include/asm-alpha/processor.h b/include/asm-alpha/processor.h
index 94afe58..6c164b9 100644
--- a/include/asm-alpha/processor.h
+++ b/include/asm-alpha/processor.h
@@ -21,7 +21,7 @@
 #define TASK_SIZE (0x40000000000UL)
 
 #define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+  (get_personality() & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
 
 #define STACK_TOP_MAX	0x00120000000UL
 
@@ -29,7 +29,7 @@
  * space during mmap's.
  */
 #define TASK_UNMAPPED_BASE \
-  ((current->personality & ADDR_LIMIT_32BIT) ? 0x40000000 : TASK_SIZE / 2)
+  ((get_personality() & ADDR_LIMIT_32BIT) ? 0x40000000 : TASK_SIZE / 2)
 
 typedef struct {
 	unsigned long seg;
-- 
1.5.3.8

