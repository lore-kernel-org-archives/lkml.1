Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZGQTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZGQTHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZGQTHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:07:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZGQTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=el1q1/wNnqxLExp4oQCMtQwoYAjpFQ9OShL9kAFWvb1ooX4w/pQkvOempUqcFvZZoz
         Ij2J9YsM7HZ6O645onOlSuTh62Frg6l5sNbQFxooEaiaCElpfmCAxA5l3P1o2p+x2Snh
         V1BhGsYWeGqroUeCUZ/4ZSteycvWx4zkNaFZw=
Date: Fri, 17 Jul 2009 23:07:36 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] headers: taskstats_kern.h redux
Message-ID: <20090717190736.GA2683@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove net/genetlink.h inclusion, now you now why sched.c was recompiled
  when you touch some networking header
* remove taskstats_kern.h inclusion from where it isn't needed, fix fallout

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/delayacct.h      |    1 -
 include/linux/taskstats_kern.h |    1 -
 kernel/delayacct.c             |    1 +
 mm/memory.c                    |    1 +
 4 files changed, 2 insertions(+), 2 deletions(-)

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
