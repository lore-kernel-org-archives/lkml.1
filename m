Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZCDUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZCDUDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZCDUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:02:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:33020 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824AbZCDUCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:02:17 -0500
Date: Wed, 4 Mar 2009 20:01:10 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236158020.29024.28.camel@penberg-laptop>
References: <1236158020.29024.28.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: move free_initrd_mem() to common mm/init.c
Message-ID: <tip-731ddea63600c24ff01e6e5144cea88bf7266ac5@git.kernel.org>
Git-Commit-ID: 731ddea63600c24ff01e6e5144cea88bf7266ac5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 20:01:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  731ddea63600c24ff01e6e5144cea88bf7266ac5
Gitweb:     http://git.kernel.org/tip/731ddea63600c24ff01e6e5144cea88bf7266ac5
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Wed, 4 Mar 2009 11:13:40 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:59:26 +0100

x86: move free_initrd_mem() to common mm/init.c

Impact: cleanup

The function is identical on 32-bit and 64-bit configurations so move it to the
common mm/init.c file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236158020.29024.28.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c    |    7 +++++++
 arch/x86/mm/init_32.c |    7 -------
 arch/x86/mm/init_64.c |    7 -------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f89df52..cc7fe66 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -71,3 +71,10 @@ void free_initmem(void)
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
 }
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_init_pages("initrd memory", start, end);
+}
+#endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 37aeaf3..c69c6b1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1275,13 +1275,6 @@ void mark_rodata_ro(void)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	free_init_pages("initrd memory", start, end);
-}
-#endif
-
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 074435e..d325186 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -963,13 +963,6 @@ void mark_rodata_ro(void)
 
 #endif
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	free_init_pages("initrd memory", start, end);
-}
-#endif
-
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
