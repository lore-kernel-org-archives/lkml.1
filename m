Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYA0JKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYA0JKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbYA0JJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:09:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbYA0JJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:09:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=HTS6HNJPOdWIKLfpH8EwIWgqTgkMPCAYlAlaLBqewV6NmrHVvTUaJhFy2u9/OrQfXpKEo+H6PqBOv8tXnZ47+tM85Lg9NCVO0BzLMneuoMT98PLjc9a+DkW3sWuQnsmvXzaN24+6wHD2QGSYaX6NXJQwwqewJzsAX3oEGUHOfzQ=
Message-ID: <479C4A36.1030300@gmail.com>
Date: Sun, 27 Jan 2008 14:39:10 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jkenisto@us.ibm.com, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] x86: Move in_kprobes_functions to linux/kprobes.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving in_kprobes_functions to linux/kprobes.h to share it with arch/x86/kerne/kprobes.c.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 6168c0a..2762145 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -39,6 +39,7 @@
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
+#include <asm-generic/sections.h>
 
 /* kprobe_status settings */
 #define KPROBE_HIT_ACTIVE	0x00000001
@@ -182,6 +183,14 @@ static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	}
 }
 
+static inline int in_kprobes_functions(unsigned long addr)
+{
+	if (addr >= (unsigned long)__kprobes_text_start &&
+	    addr < (unsigned long)__kprobes_text_end)
+		return -EINVAL;
+	return 0;
+}
+
 #ifdef CONFIG_KPROBES_SANITY_TEST
 extern int init_test_probes(void);
 #else
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d0493ea..0b74dfb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -490,14 +490,6 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 	return ret;
 }
 
-static int __kprobes in_kprobes_functions(unsigned long addr)
-{
-	if (addr >= (unsigned long)__kprobes_text_start &&
-	    addr < (unsigned long)__kprobes_text_end)
-		return -EINVAL;
-	return 0;
-}
-
 static int __kprobes __register_kprobe(struct kprobe *p,
 	unsigned long called_from)
 {

