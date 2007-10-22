Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbXJVDoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbXJVDoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXJVDoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:44:22 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:14471 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXJVDoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:44:22 -0400
X-IronPort-AV: i="4.21,309,1188792000"; 
   d="scan'208"; a="42169170:sNHT27088467"
Subject: [GIT PULL Part #3] Blackfin arch bug fixing for merge window
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Mon, 22 Oct 2007 11:44:16 +0800
Message-Id: <1193024656.19886.4.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 22 Oct 2007 03:44:20.0582 (UTC) FILETIME=[D4445060:01C8145D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git
for-linus

to receive the following updates:

 arch/blackfin/Makefile       |    4 ++--
 arch/blackfin/kernel/setup.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Bryan Wu (1):
      Blackfin arch: use KBUILD_CFLAGS and KBUILD_AFLAGS in Makefile

Mike Frysinger (1):
      Blackfin arch: Javier Herrer writes: fix building when icache and
dcache is disabled

diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 3c87291..f7cac7c 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -12,8 +12,8 @@ LDFLAGS_vmlinux  := -X
 OBJCOPYFLAGS     := -O binary -R .note -R .comment -S
 GZFLAGS          := -9
 
-CFLAGS           += $(call cc-option,-mno-fdpic)
-AFLAGS           += $(call cc-option,-mno-fdpic)
+KBUILD_CFLAGS           += $(call cc-option,-mno-fdpic)
+KBUILD_AFLAGS           += $(call cc-option,-mno-fdpic)
 CFLAGS_MODULE    += -mlong-calls
 KALLSYMS         += --symbol-prefix=_
 
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 0e74644..f1b059e 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -501,7 +501,7 @@ EXPORT_SYMBOL(sclk_to_usecs);
 
 unsigned long usecs_to_sclk(unsigned long usecs)
 {
-	return get_sclk() / (USEC_PER_SEC * (u64)usecs);
+	return (get_sclk() * (u64)usecs) / USEC_PER_SEC;
 }
 EXPORT_SYMBOL(usecs_to_sclk);
 
@@ -589,7 +589,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 #elif defined CONFIG_BFIN_WT
 		"wt"
 #endif
-		, 0);
+		"", 0);
 
 	seq_printf(m, "%s\n", cache);
 
