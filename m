Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbZEHICz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbZEHICz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZEHICV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:02:21 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37390 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZEHICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:02:19 -0400
Message-ID: <4A03E707.30304@monstr.eu>
Date: Fri, 08 May 2009 10:02:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.30-rc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal



The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Michal Simek (1):
      microblaze: Fix return value for sys_ipc

Tobias Klauser (1):
      microblaze: Storage class should be before const qualifier

 arch/microblaze/kernel/cpu/cpuinfo-static.c |    4 ++--
 arch/microblaze/kernel/sys_microblaze.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c b/arch/microblaze/kernel/cpu/cpuinfo-static.c
index cfe44ef..450ca6b 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-static.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -14,8 +14,8 @@
 #include <asm/cpuinfo.h>
 #include <asm/pvr.h>

-const static char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
-const static char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
+static const char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
+static const char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;

 #define err_printk(x) \
        early_printk("ERROR: Microblaze " x "- different for kernel and DTS\n");
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index ba0568c..31905ff 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -131,7 +131,7 @@ sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
                ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
                break;
        }
-       return -EINVAL;
+       return ret;
 }

 asmlinkage int sys_vfork(struct pt_regs *regs)




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
