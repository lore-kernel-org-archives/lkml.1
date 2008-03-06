Return-Path: <linux-kernel-owner+w=401wt.eu-S934294AbYCFN1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbYCFN1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYCFN1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:27:40 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:57970 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYCFN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:27:39 -0500
Message-ID: <47CFF148.8050608@tiscali.nl>
Date: Thu, 06 Mar 2008 14:27:36 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc64: aout32_core_dump(): convert strncpy(x, y, sizeof(x))
 to strlcpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was not yet tested. Please confirm it's right.
---
strncpy does not append '\0' if the length of the source string equals
the size parameter, strlcpy does.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/sparc64/kernel/binfmt_aout32.c b/arch/sparc64/kernel/binfmt_aout32.c
index 9877f2d..0a63d18 100644
--- a/arch/sparc64/kernel/binfmt_aout32.c
+++ b/arch/sparc64/kernel/binfmt_aout32.c
@@ -100,7 +100,7 @@ static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file,
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
-       	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
+	strlcpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.signal = signr;
 	aout_dump_thread(regs, &dump);
 
