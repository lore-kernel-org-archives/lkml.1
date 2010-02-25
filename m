Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab0BYPy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:54:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35392 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360Ab0BYPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:54:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CKq4zX/8rALgSfqO894KoIgoHGng2epGlDgn7x03UZWfzaubXcahFaSySzrgPAVB9h
         l9kMq9PamBj/NfmOVqHZ7BlCIo7o6vFLUp4UMgcqDJMe+NBaZcYm7x8WSRqZojgxXgRB
         /bEqWT8SlwfiHqLrpNF94lRs8HJ+WwyBB088c=
Date: Thu, 25 Feb 2010 23:54:19 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       HIRANO Takahito <hiranotaka@zng.info>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Miroslav Sustek <sustmidown@centrum.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/07] kernel.h int_sqrt cleanup
Message-ID: <20100225155419.GA2724@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

int_sqrt in kernel.h should be put into a standalone head file

cleanup int_sqrt declarations in kernel.h, put them into int_sqrt.h
include int_sqrt.h in every file which need it

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/media/dvb/pt1/va1j5jf8007s.c     |    1 +
 drivers/media/video/cx88/cx88-dsp.c      |    1 +
 drivers/net/wireless/b43/phy_lp.c        |    1 +
 drivers/staging/comedi/drivers/vmk80xx.c |    1 +
 drivers/video/fbmon.c                    |    1 +
 fs/nfs/write.c                           |    1 +
 include/linux/int_sqrt.h                 |    6 ++++++
 include/linux/kernel.h                   |    2 --
 lib/int_sqrt.c                           |    1 +
 mm/memcontrol.c                          |    1 +
 mm/oom_kill.c                            |    1 +
 mm/page_alloc.c                          |    1 +
 net/ipv4/route.c                         |    1 +
 13 files changed, 17 insertions(+), 2 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/int_sqrt.h	2010-02-25 21:00:28.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _INT_SQRT_H
+#define _INT_SQRT_H
+
+extern unsigned long int_sqrt(unsigned long);
+
+#endif
--- linux-2.6.orig/drivers/media/dvb/pt1/va1j5jf8007s.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/drivers/media/dvb/pt1/va1j5jf8007s.c	2010-02-25 21:00:28.000000000 +0800
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/int_sqrt.h>
 #include "dvb_frontend.h"
 #include "va1j5jf8007s.h"
 
--- linux-2.6.orig/drivers/media/video/cx88/cx88-dsp.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/drivers/media/video/cx88/cx88-dsp.c	2010-02-25 21:00:28.000000000 +0800
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <linux/int_sqrt.h>
 #include <asm/div64.h>
 
 #include "cx88.h"
--- linux-2.6.orig/drivers/net/wireless/b43/phy_lp.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/drivers/net/wireless/b43/phy_lp.c	2010-02-25 21:00:28.000000000 +0800
@@ -23,6 +23,7 @@
 
 */
 
+#include <linux/int_sqrt.h>
 #include "b43.h"
 #include "main.h"
 #include "phy_lp.h"
--- linux-2.6.orig/drivers/staging/comedi/drivers/vmk80xx.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/drivers/staging/comedi/drivers/vmk80xx.c	2010-02-25 21:00:28.000000000 +0800
@@ -61,6 +61,7 @@ Changelog:
 #include <linux/poll.h>
 #include <linux/usb.h>
 #include <linux/uaccess.h>
+#include <linux/int_sqrt.h>
 
 #include "../comedidev.h"
 
--- linux-2.6.orig/drivers/video/fbmon.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/drivers/video/fbmon.c	2010-02-25 21:00:28.000000000 +0800
@@ -29,6 +29,7 @@
 #include <linux/fb.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/int_sqrt.h>
 #include <video/edid.h>
 #ifdef CONFIG_PPC_OF
 #include <asm/prom.h>
--- linux-2.6.orig/fs/nfs/write.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/fs/nfs/write.c	2010-02-25 21:00:28.000000000 +0800
@@ -20,6 +20,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/int_sqrt.h>
 
 #include <asm/uaccess.h>
 
--- linux-2.6.orig/lib/int_sqrt.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/lib/int_sqrt.c	2010-02-25 21:00:28.000000000 +0800
@@ -1,6 +1,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/int_sqrt.h>
 
 /**
  * int_sqrt - rough approximation to sqrt
--- linux-2.6.orig/mm/memcontrol.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/mm/memcontrol.c	2010-02-25 21:00:28.000000000 +0800
@@ -39,6 +39,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
+#include <linux/int_sqrt.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
--- linux-2.6.orig/mm/oom_kill.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/mm/oom_kill.c	2010-02-25 21:00:28.000000000 +0800
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
 #include <linux/security.h>
+#include <linux/int_sqrt.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
--- linux-2.6.orig/mm/page_alloc.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/mm/page_alloc.c	2010-02-25 21:00:28.000000000 +0800
@@ -49,6 +49,7 @@
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
+#include <linux/int_sqrt.h>
 #include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
--- linux-2.6.orig/net/ipv4/route.c	2010-02-25 20:59:59.000000000 +0800
+++ linux-2.6/net/ipv4/route.c	2010-02-25 21:00:28.000000000 +0800
@@ -104,6 +104,7 @@
 #include <net/xfrm.h>
 #include <net/netevent.h>
 #include <net/rtnetlink.h>
+#include <linux/int_sqrt.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
--- linux-2.6.orig/include/linux/kernel.h	2010-02-25 21:00:25.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-25 21:00:54.000000000 +0800
@@ -151,8 +151,6 @@ extern int func_ptr_is_kernel_text(void 
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-unsigned long int_sqrt(unsigned long);
-
 extern void bust_spinlocks(int yes);
 extern int root_mountflags;
 
