Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZDUNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZDUNFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZDUNEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:04:52 -0400
Received: from elvis.franken.de ([193.175.24.41]:37505 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZDUNEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:04:51 -0400
X-Greylist: delayed 4829 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 09:04:51 EDT
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] Fix SYSCALL_ALIAS for older MIPS assembler
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
cc: torvalds@linux-foundation.org
Message-Id: <20090421114413.B493CC3318@solo.franken.de>
Date: Tue, 21 Apr 2009 13:44:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older MIPS assembler don't support .set for defining aliases.
Using = works for old and new assembers.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---

 include/linux/syscalls.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index dabe4ad..40617c1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -148,7 +148,7 @@ struct old_linux_dirent;
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
 	     "\t.globl ." #alias "\n\t.set ." #alias ", ." #name)
 #else
-#ifdef CONFIG_ALPHA
+#if defined(CONFIG_ALPHA) || defined(CONFIG_MIPS)
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ( #alias " = " #name "\n\t.globl " #alias)
 #else
