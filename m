Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbZLNWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbZLNWYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZLNWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:24:30 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:42488 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbZLNWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:24:29 -0500
X-Spam-Processed: digidescorp.com, Mon, 14 Dec 2009 16:24:29 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1599c783b1=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH v2] microblaze: nommu: Don't clobber R11 on syscalls
Date: Mon, 14 Dec 2009 16:24:18 -0600
Message-Id: <1260829458-7503-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The noMMU syscall trap has a bug that causes R11 to be zero on return to 
userland. Remove the extra "save" of R11 responsible for the bug, as well
as an unnecessary extra "load".

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
--- a/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:05:11.000000000 -0600
+++ b/arch/microblaze/kernel/entry-nommu.S	2009-12-14 11:29:37.000000000 -0600
@@ -208,8 +208,6 @@ ENTRY(_user_exception)
 	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
 	/* calculate kernel stack pointer */
 	addik	r1, r1, THREAD_SIZE - PT_SIZE
-	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
-	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
 2:
 	swi	r11, r1, PT_MODE		/* store the mode */
 	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */

