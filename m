Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZIRNr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZIRNr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZIRNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:47:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:6624 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZIRNr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G5jQV7zJIGw1yeOCnRYzUdKGSrn4tyasVTbCA6oli//suVshvedFKO3BlwjoOQggii
         RyAen4VzHEhOujLantKFr0x+dgZJ0mYVUs4JM1rYpgf3TKPDMdPcRxWP5xQEv0cZ4hSW
         vkj1i46V8Ps0ip94bDdLUV04oVsVTL0ixcytw=
Date: Fri, 18 Sep 2009 23:55:55 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: taskstats_kern.h trim
Message-ID: <20090918195555.GA12637@core2.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove net/genetlink.h inclusion, now sched.c won't be recompiled
because of some networking changes.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -18,7 +18,6 @@
 #define _LINUX_DELAYACCT_H
 
 #include <linux/sched.h>
-#include <linux/taskstats_kern.h>
 
 /*
  * Per-task flags relevant to delay accounting
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -9,7 +9,6 @@
 
 #include <linux/taskstats.h>
 #include <linux/sched.h>
-#include <net/genetlink.h>
 
 #ifdef CONFIG_TASKSTATS
 extern struct kmem_cache *taskstats_cache;
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -15,6 +15,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/taskstats.h>
 #include <linux/time.h>
 #include <linux/sysctl.h>
 #include <linux/delayacct.h>
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -56,6 +56,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 
+#include <asm/io.h>
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
