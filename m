Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYCNB6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYCNB6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCNB6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:58:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39733 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYCNB6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:58:30 -0400
Date: Thu, 13 Mar 2008 21:58:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] KERNEL:  Explicitly include required header files under
 kernel/.
Message-ID: <alpine.LFD.1.00.0803132154290.11934@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following an experimental deletion of the unnecessary directive

 #include <linux/slab.h>

from the header file <linux/percpu.h>, these files under kernel/ were
exposed as needing to include one of <linux/slab.h> or <linux/gfp.h>,
so explicit includes were added where necessary.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 kernel/irq/devres.c     |    1 +
 kernel/irq/manage.c     |    1 +
 kernel/marker.c         |    1 +
 kernel/ns_cgroup.c      |    1 +
 kernel/rcutorture.c     |    1 +
 kernel/res_counter.c    |    1 +
 kernel/time.c           |    1 +
 kernel/user_namespace.c |    1 +
 kernel/utsname.c        |    1 +
 9 files changed, 9 insertions(+)

diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index 6d9204f..38a25b8 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -1,6 +1,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/gfp.h>

 /*
  * Device resource management aware IRQ request/free implementation.
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 438a014..46e4ad1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>

 #include "internals.h"

diff --git a/kernel/marker.c b/kernel/marker.c
index 48a4ea5..5685f51 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/marker.h>
 #include <linux/err.h>
+#include <linux/slab.h>

 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
index aead4d6..18df038 100644
--- a/kernel/ns_cgroup.c
+++ b/kernel/ns_cgroup.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
+#include <linux/slab.h>

 struct ns_cgroup {
 	struct cgroup_subsys_state css;
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index fd59982..8e8b85a 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -45,6 +45,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/slab.h>

 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index efbfc0f..a508c27 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/parser.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 #include <linux/res_counter.h>
 #include <linux/uaccess.h>

diff --git a/kernel/time.c b/kernel/time.c
index a5ec013..adca7f5 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -35,6 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
+#include <linux/slab.h>

 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4c90062..2731ba8 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/nsproxy.h>
+#include <linux/slab.h>
 #include <linux/user_namespace.h>

 /*
diff --git a/kernel/utsname.c b/kernel/utsname.c
index 816d7b2..64d398f 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <linux/version.h>
 #include <linux/err.h>
+#include <linux/slab.h>

 /*
  * Clone a new ns copying an original utsname, setting refcount to 1



========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
