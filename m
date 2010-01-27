Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187Ab0A0P0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0A0P0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919Ab0A0P0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:26:15 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:40163 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab0A0P0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:26:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YkHO3v8drf8WMgH6nyh7D6yzsfkrIkHAhfaut6UyKL3MwoIb50e0VWSeRrmNQ24tho
         uQ1mGQvCeXNCPUQpJg/Rzf4RZkg7LOBtcQtmmnQ944aGEN+Q3PQre2WZ31TTC79INKU3
         hvyCxk+Ita4mcSijpinVJr/Si6gbE4ANp9/XQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH rt/2.6.31 v1] [RT] kernel/sched.c: Fixup of "implicit declaration of function '_finish_arch_switch'"
Date: Wed, 27 Jan 2010 23:20:08 +0800
Message-Id: <280c83a7cd3da0d2a822f27dd9739253cccc4330.1264605513.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

(This v1 revision add the missing "h" of _finish_arch_switch)

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
index 590b9bb..230a7de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -959,6 +959,8 @@ static inline u64 global_rt_runtime(void)
 #endif
 #ifndef finish_arch_switch
 # define _finish_arch_switch(prev)	do { } while (0)
+#else
+# define _finish_arch_switch		finish_arch_switch
 #endif
 
 static inline int task_current(struct rq *rq, struct task_struct *p)
-- 
1.6.6

