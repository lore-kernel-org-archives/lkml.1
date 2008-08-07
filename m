Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYHGMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYHGMb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYHGMah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:30:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:58819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbYHGMaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="426898511"
Subject: [PATCH 1/6] kexec jump: clean up #ifdef and comments
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:05:23 +0800
Message-Id: <1218099923.5164.32.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move if (kexec_image->preserve_context) { ... } into #ifdef
CONFIG_KEXEC_JUMP to make code looks cleaner.

Fix no longer correct comments of kernel_kexec().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 kernel/kexec.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1427,8 +1427,6 @@ static int __init crash_save_vmcoreinfo_
 module_init(crash_save_vmcoreinfo_init)
 
 /**
- *	kernel_kexec - reboot the system
- *
  *	Move into place and start executing a preloaded standalone
  *	executable.  If nothing was preloaded return an error.
  */
@@ -1443,8 +1441,8 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
-	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context) {
 		mutex_lock(&pm_mutex);
 		pm_prepare_console();
 		error = freeze_processes();
@@ -1471,8 +1469,9 @@ int kernel_kexec(void)
 		if (error)
 			goto Enable_irqs;
 		save_processor_state();
+	} else
 #endif
-	} else {
+	{
 		blocking_notifier_call_chain(&reboot_notifier_list,
 					     SYS_RESTART, NULL);
 		system_state = SYSTEM_RESTART;
@@ -1484,8 +1483,8 @@ int kernel_kexec(void)
 
 	machine_kexec(kexec_image);
 
-	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context) {
 		restore_processor_state();
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
@@ -1499,8 +1498,8 @@ int kernel_kexec(void)
  Restore_console:
 		pm_restore_console();
 		mutex_unlock(&pm_mutex);
-#endif
 	}
+#endif
 
  Unlock:
 	xchg(&kexec_lock, 0);


