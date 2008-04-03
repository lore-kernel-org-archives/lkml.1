Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbYDCTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbYDCTi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbYDCTdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:15 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53032
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 25/35] x86: make native_machine_shutdown non-static
Date: Thu,  3 Apr 2008 22:32:40 +0300
Message-Id: <1207251170-5013-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

it will allow external users to call it. It is mainly
useful for routines that will override its machine_ops
field for its own special purposes, but want to call the
normal shutdown routine after they're done

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/reboot.c |    2 +-
 include/asm-x86/reboot.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 708d6f8..1481d85 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -400,7 +400,7 @@ static void native_machine_emergency_restart(void)
 	}
 }
 
-static void native_machine_shutdown(void)
+void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
diff --git a/include/asm-x86/reboot.h b/include/asm-x86/reboot.h
index ff9b546..c5e8722 100644
--- a/include/asm-x86/reboot.h
+++ b/include/asm-x86/reboot.h
@@ -17,5 +17,6 @@ extern struct machine_ops machine_ops;
 
 void machine_real_restart(unsigned char *code, int length);
 void native_machine_crash_shutdown(struct pt_regs *regs);
+void native_machine_shutdown(void);
 
 #endif	/* _ASM_REBOOT_H */
-- 
1.5.4.5

