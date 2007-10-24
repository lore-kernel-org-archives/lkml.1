Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXJXQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXJXQ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbXJXQXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33346 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758413AbXJXQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:15 -0400
Date: Wed, 24 Oct 2007 18:23:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kernel_shutdown_prepare() static
Message-ID: <20071024162345.GV30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_shutdown_prepare() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/reboot.h |    2 --
 kernel/sys.c           |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 85ea63f..b93b541 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -59,8 +59,6 @@ extern void machine_crash_shutdown(struct pt_regs *);
  * Architecture independent implemenations of sys_reboot commands.
  */
 
-extern void kernel_shutdown_prepare(enum system_states state);
-
 extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
diff --git a/kernel/sys.c b/kernel/sys.c
index 304b541..4c77ed2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -315,7 +315,7 @@ static void kernel_kexec(void)
 #endif
 }
 
-void kernel_shutdown_prepare(enum system_states state)
+static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
 		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);

