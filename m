Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812Ab0AYWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0AYWLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0AYWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:11:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:40784 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AYWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:11:10 -0500
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, Himanshu Chauhan <hschauhan@nulltrace.org>
Subject: [PATCH] Handling unhandled BOOT_UNDECIDED as normal reboot
Date: Tue, 26 Jan 2010 03:32:01 +0530
Message-Id: <1264456921-13846-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The follow patch fixes the following warning:
 warning: enumeration value BOOT_UNDECIDED not handled in switch
by handling UNDECIDED type as a usual reboot (BOOT_KBD).

Is this okay?

Regards
Himanshu

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
---
 arch/x86/kernel/reboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5e78483..69c1c18 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -573,6 +573,7 @@ static void native_machine_emergency_restart(void)
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
+		case BOOT_UNDECIDED: /* for unknown type usual reboot */
 		case BOOT_KBD:
 			mach_reboot_fixups(); /* for board specific fixups */
 
-- 
1.6.3.3

