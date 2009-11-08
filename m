Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZKHP3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZKHP3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZKHP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:29:11 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40107 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZKHP3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XZpzQ70GDzQpJnuvUafIICV9celIdBODrag74t4Ih2GXgQF41sUt+gpf/wz5iyNj49
         Y/e8VPYhcIXst6OVXLxErb5Y2BxhBMt3Vh472y/AE7ulsrd7CRcs2dkzA8eDUW++kCBb
         1wS7BYnm7G4r8BB4JwrDjPiN3pbotZrwWyLnA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4/7 v6] hw-breakpoint: Move asm-generic/hw_breakpoint.h to linux/hw_breakpoint.h
Date: Sun,  8 Nov 2009 16:28:58 +0100
Message-Id: <1257694141-5670-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to make the breakpoints parameters generic among architectures.
For that it's better to move the asm-generic header to a generic linux
header.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h           |    2 +-
 include/{asm-generic => linux}/hw_breakpoint.h |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)
 rename include/{asm-generic => linux}/hw_breakpoint.h (96%)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 1acb4d4..3cfca8e 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -12,7 +12,7 @@ struct arch_hw_breakpoint {
 };
 
 #include <linux/kdebug.h>
-#include <asm-generic/hw_breakpoint.h>
+#include <linux/hw_breakpoint.h>
 
 /* Available HW breakpoint length encodings */
 #define HW_BREAKPOINT_LEN_1		0x40
diff --git a/include/asm-generic/hw_breakpoint.h b/include/linux/hw_breakpoint.h
similarity index 96%
rename from include/asm-generic/hw_breakpoint.h
rename to include/linux/hw_breakpoint.h
index 9bf2d12..61ccc8f 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,9 +1,6 @@
-#ifndef	_ASM_GENERIC_HW_BREAKPOINT_H
-#define	_ASM_GENERIC_HW_BREAKPOINT_H
+#ifndef _LINUX_HW_BREAKPOINT_H
+#define _LINUX_HW_BREAKPOINT_H
 
-#ifndef __ARCH_HW_BREAKPOINT_H
-#error "Please don't include this file directly"
-#endif
 
 #ifdef	__KERNEL__
 #include <linux/list.h>
@@ -136,4 +133,4 @@ extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 extern unsigned int hbp_kernel_pos;
 
 #endif	/* __KERNEL__ */
-#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
+#endif	/* _LINUX_HW_BREAKPOINT_H */
-- 
1.6.2.3

