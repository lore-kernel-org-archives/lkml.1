Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZIXAdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZIXAdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZIXAdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:33:06 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39153 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbZIXAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:30:16 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Nathan Lynch <ntl@pobox.com>
Subject: [PATCH v18 78/80] powerpc: wire up checkpoint and restart syscalls
Date: Wed, 23 Sep 2009 19:51:58 -0400
Message-Id: <1253749920-18673-79-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 arch/powerpc/include/asm/systbl.h |    2 ++
 arch/powerpc/include/asm/unistd.h |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 370600c..3d44cf3 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -326,3 +326,5 @@ SYSCALL_SPU(perf_counter_open)
 COMPAT_SYS_SPU(preadv)
 COMPAT_SYS_SPU(pwritev)
 COMPAT_SYS(rt_tgsigqueueinfo)
+SYSCALL(checkpoint)
+SYSCALL(restart)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index cef080b..ef41ebb 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -345,10 +345,12 @@
 #define __NR_preadv		320
 #define __NR_pwritev		321
 #define __NR_rt_tgsigqueueinfo	322
+#define __NR_checkpoint		323
+#define __NR_restart		324
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		323
+#define __NR_syscalls		325
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.6.0.4

