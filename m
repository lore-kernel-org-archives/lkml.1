Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZLIXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZLIXNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbZLIXNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:13:46 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:42296 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbZLIXNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:13:45 -0500
X-Spam-Processed: digidescorp.com, Wed, 09 Dec 2009 17:13:53 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.25.96
X-Return-Path: prvs=159454a256=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: nommu: Don't clobber R11 on syscalls
Date: Wed,  9 Dec 2009 17:13:42 -0600
Message-Id: <1260400422-2805-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The noMMU syscall trap has a bug that causes R11 to be zero on return to 
userland. Remove the extra "save" of R11 responsible for the bug.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
--- a/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:05:11.000000000 -0600
+++ b/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:07:31.000000000 -0600
@@ -208,7 +208,6 @@ ENTRY(_user_exception)
 	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
 	/* calculate kernel stack pointer */
 	addik	r1, r1, THREAD_SIZE - PT_SIZE
-	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
 	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
 2:
 	swi	r11, r1, PT_MODE		/* store the mode */

