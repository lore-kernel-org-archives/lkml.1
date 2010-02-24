Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0BXVDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:03:49 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:45665 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab0BXVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:03:48 -0500
X-Spam-Processed: digidescorp.com, Wed, 24 Feb 2010 14:54:26 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=167138bab6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: Fix "kstack=" parsing
Date: Wed, 24 Feb 2010 14:54:15 -0600
Message-Id: <1267044855-6949-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "kstack=" command line parameter is not parsed correctly.
All proper values are interpreted as zero.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
--- a/arch/microblaze/kernel/traps.c	2010-02-24 14:12:01.000000000 -0600
+++ b/arch/microblaze/kernel/traps.c	2010-02-24 14:48:47.000000000 -0600
@@ -22,13 +22,11 @@ void trap_init(void)
 	__enable_hw_exceptions();
 }
 
-static int kstack_depth_to_print = 24;
+static unsigned long kstack_depth_to_print = 24;
 
 static int __init kstack_setup(char *s)
 {
-	kstack_depth_to_print = strict_strtoul(s, 0, NULL);
-
-	return 1;
+	return !strict_strtoul(s, 0, &kstack_depth_to_print);
 }
 __setup("kstack=", kstack_setup);
 


