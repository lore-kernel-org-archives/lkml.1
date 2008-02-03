Return-Path: <linux-kernel-owner+w=401wt.eu-S936320AbYBCGTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320AbYBCGTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbYBCGTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:19:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbYBCGTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:19:09 -0500
Message-ID: <47A55CA4.9090804@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 14:18:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix compile waring building without CONFIG_SYSCTL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


building without CONFIG_SYSCTL:

arch/x86/kernel/nmi_64.c:50: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined

This patch also fixes nmi_32.c

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 arch/x86/kernel/nmi_32.c |    3 ++-
 arch/x86/kernel/nmi_64.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index edd4136..7e5ee4f 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -46,8 +46,9 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
+#ifdef CONFIG_SYSCTL
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
+#endif
 
 static int endflag __initdata = 0;
 
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index fb99484..8fff383 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -46,8 +46,9 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
+#ifdef CONFIG_SYSCTL
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
+#endif
 
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
-- 
1.5.4.rc3
