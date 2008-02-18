Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbYBRVCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbYBRVCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYBRVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:02:42 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:59078 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYBRVCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:02:42 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [MIPS] Enable the timerfd_*() o32 system calls
Date: Tue, 19 Feb 2008 00:02:37 +0300
Message-Id: <1203368557-32356-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the system calls timerfd_create(), timerfd_settime()
and timerfd_gettime() for MIPS architecture.

Please see the following Bugzilla entry for more details:

http://bugzilla.kernel.org/show_bug.cgi?id=10038

This was tested using a Malta 4Kc board in both little-endian and
big-endian modes. The unit test program is available from the URL
above.

Note that only the "o32"-style system calls have been added. This is
due to the fact that I have no suitable equipment to test the other
flavors of MIPS ABI.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/kernel/scall32-o32.S |    3 +++
 include/asm-mips/unistd.h      |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index f798139..08a9c50 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -663,6 +663,9 @@ einval:	li	v0, -EINVAL
 	sys	sys_ni_syscall		0
 	sys	sys_eventfd		1
 	sys	sys_fallocate		6	/* 4320 */
+	sys	sys_timerfd_create	2
+	sys	sys_timerfd_gettime	2
+	sys	sys_timerfd_settime	4
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff --git a/include/asm-mips/unistd.h b/include/asm-mips/unistd.h
index fa9a587..7316b55 100644
--- a/include/asm-mips/unistd.h
+++ b/include/asm-mips/unistd.h
@@ -341,16 +341,19 @@
 #define __NR_timerfd			(__NR_Linux + 318)
 #define __NR_eventfd			(__NR_Linux + 319)
 #define __NR_fallocate			(__NR_Linux + 320)
+#define __NR_timerfd_create		(__NR_Linux + 321)
+#define __NR_timerfd_gettime		(__NR_Linux + 322)
+#define __NR_timerfd_settime		(__NR_Linux + 323)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		320
+#define __NR_Linux_syscalls		323
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		320
+#define __NR_O32_Linux_syscalls		323
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
-- 
1.5.3

