Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbYIXBzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbYIXBzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 21:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYIXBzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 21:55:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYIXBzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 21:55:07 -0400
From: Jeremy Katz <katzj@redhat.com>
To: mingo@redhat.com
Cc: dsaxena@laptop.org, linux-kernel@vger.kernel.org, dilinger@laptop.org,
       Jeremy Katz <katzj@redhat.com>
Subject: [PATCH] Disable apm on the olpc
Date: Tue, 23 Sep 2008 21:54:00 -0400
Message-Id: <1222221240-6028-1-git-send-email-katzj@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OLPC doesn't support APM but also doesn't have DMI, so we can't detect
and disable it based on DMI data.  So, just disable based on machine_is_olpc()

Signed-off-by: Jeremy Katz <katzj@redhat.com>
---
 arch/x86/kernel/apm_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 9ee24e6..732d1f4 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -234,6 +234,7 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/i8253.h>
+#include <asm/olpc.h>
 #include <asm/paravirt.h>
 #include <asm/reboot.h>
 
@@ -2217,7 +2218,7 @@ static int __init apm_init(void)
 
 	dmi_check_system(apm_dmi_table);
 
-	if (apm_info.bios.version == 0 || paravirt_enabled()) {
+	if (apm_info.bios.version == 0 || paravirt_enabled() || machine_is_olpc()) {
 		printk(KERN_INFO "apm: BIOS not found.\n");
 		return -ENODEV;
 	}
-- 
1.6.0.1

