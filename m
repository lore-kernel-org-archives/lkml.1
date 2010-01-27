Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923Ab0A0PTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0A0PTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418Ab0A0PTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:19:08 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:47874 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0A0PTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RfR0s5+YVRIAKJQnidcAuvnS3XM2spP/OsEF0AwfgcXuEZjQ/IJdlU5J62L35uvxbK
         c4lBwZzogWxPuR0M9hvqUvGpuSM2vXYhuko7WIUT9mAsMzHozSzi6ljO2Y4IqxAWJ4aT
         WrWaD5MSt8nSqe+PRQu7N+Dqz4wkxl1d4Cmic=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH rt/2.6.31] [RT] kernel/sched.c: Fixup of "implicit declaration of function '_finish_arch_switch'"
Date: Wed, 27 Jan 2010 23:12:55 +0800
Message-Id: <4dc11af5f8e10e716e94f4b6b886d1160a5a1744.1264605070.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch fixes the following error:

kernel/sched.c: In function 'finish_task_switch':
kernel/sched.c:2979: error: implicit declaration of function
'_finish_arch_switch'

The following archs have defined their finish_arch_switch:

$ grep finish_arch_switch -ur arch/
arch/s390/include/asm/system.h:#define finish_arch_switch(prev)
arch/sh/include/asm/system_32.h:#define finish_arch_switch(prev
arch/avr32/include/asm/system.h:#define finish_arch_switch(prev)
arch/mips/include/asm/system.h:#define finish_arch_switch(prev)

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 590b9bb..739156e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -959,6 +959,8 @@ static inline u64 global_rt_runtime(void)
 #endif
 #ifndef finish_arch_switch
 # define _finish_arch_switch(prev)	do { } while (0)
+#else
+# define _finish_arch_switc		finish_arch_switch
 #endif
 
 static inline int task_current(struct rq *rq, struct task_struct *p)
-- 
1.6.6

