Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbXLTUMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbXLTUMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbXLTULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:11:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758797AbXLTULD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:11:03 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 12/15] add CLBR_ defines for x86_64.
Date: Thu, 20 Dec 2007 18:04:07 -0200
Message-Id: <1198181348746-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981813384090-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com> <11981813384090-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 needs a potentially larger clobber list than i386, due to its calling
convention. So we add more CLBR_ defines for it.
Note that CLBR_ANY is different for each of the architectures, since it comprises
the notion of "All call clobbers in this architecture"

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:08:06.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:08:10.000000000 -0800
@@ -8,11 +8,24 @@
 #include <asm/asm.h>
 
 /* Bitmask of what can be clobbered: usually at least eax. */
-#define CLBR_NONE 0x0
-#define CLBR_EAX 0x1
-#define CLBR_ECX 0x2
-#define CLBR_EDX 0x4
-#define CLBR_ANY 0x7
+#define CLBR_NONE 0
+#define CLBR_EAX  (1 << 0)
+#define CLBR_ECX  (1 << 1)
+#define CLBR_EDX  (1 << 2)
+
+#ifdef CONFIG_X86_64
+#define CLBR_RSI  (1 << 3)
+#define CLBR_RDI  (1 << 4)
+#define CLBR_R8   (1 << 5)
+#define CLBR_R9   (1 << 6)
+#define CLBR_R10  (1 << 7)
+#define CLBR_R11  (1 << 8)
+#define CLBR_ANY  ((1 << 9) - 1)
+#include <asm/desc_defs.h>
+#else
+/* CLBR_ANY should match all regs platform has. For i386, that's just it */
+#define CLBR_ANY  ((1 << 3) - 1)
+#endif /* X86_64 */
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
