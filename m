Return-Path: <linux-kernel-owner+w=401wt.eu-S1761880AbXESONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761880AbXESONz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 10:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbXESONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 10:13:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57583 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbXESONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 10:13:47 -0400
X-Originating-Ip: 72.143.65.211
Date: Sat, 19 May 2007 10:11:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH][REVISED] Remove unnecessary includes of spinlock.h from
 include/linux/ header files.
Message-ID: <Pine.LNX.4.64.0705190941190.7559@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the unnecessary includes of <linux/spinlock.h> from other
header files in include/linux/, and fix the couple of errors that pop
up because of that.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  whoops, a slight fix from the earlier version, as the previous patch
failed the headers_check since an include was added back in the wrong
location in one of the files.

  compile-tested and header-checked on x86 with "make allyesconfig".


 include/linux/attribute_container.h |    1 -
 include/linux/capability.h          |    1 -
 include/linux/console.h             |    1 -
 include/linux/ds17287rtc.h          |    1 -
 include/linux/ipc.h                 |    1 +
 include/linux/leds.h                |    1 -
 include/linux/module.h              |    1 -
 include/linux/percpu.h              |    2 +-
 include/linux/scx200_gpio.h         |    2 --
 include/linux/signal.h              |    1 -
 include/linux/smp_lock.h            |    1 -
 include/linux/timer.h               |    1 -
 12 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index 93bfb0b..8ff2749 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -12,7 +12,6 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/klist.h>
-#include <linux/spinlock.h>

 struct attribute_container {
 	struct list_head	node;
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 6548b35..a9d7b01 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -42,7 +42,6 @@ typedef struct __user_cap_data_struct {

 #ifdef __KERNEL__

-#include <linux/spinlock.h>
 #include <asm/current.h>

 /* #define STRICT_CAP_T_TYPECHECKS */
diff --git a/include/linux/console.h b/include/linux/console.h
index 62ef6e1..dc4405d 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -15,7 +15,6 @@
 #define _LINUX_CONSOLE_H_ 1

 #include <linux/types.h>
-#include <linux/spinlock.h>

 struct vc_data;
 struct console_font_op;
diff --git a/include/linux/ds17287rtc.h b/include/linux/ds17287rtc.h
index c281ba4..d85d3f4 100644
--- a/include/linux/ds17287rtc.h
+++ b/include/linux/ds17287rtc.h
@@ -11,7 +11,6 @@
 #define __LINUX_DS17287RTC_H

 #include <linux/rtc.h>			/* get the user-level API */
-#include <linux/spinlock.h>		/* spinlock_t */
 #include <linux/mc146818rtc.h>

 /* Register A */
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 1980867..7c8c6d8 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -52,6 +52,7 @@ struct ipc_perm
 #ifdef __KERNEL__

 #include <linux/kref.h>
+#include <linux/spinlock.h>

 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 88afcef..494bed7 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -13,7 +13,6 @@
 #define __LINUX_LEDS_H_INCLUDED

 #include <linux/list.h>
-#include <linux/spinlock.h>

 struct device;
 struct class_device;
diff --git a/include/linux/module.h b/include/linux/module.h
index e6e0f86..b6a646c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -6,7 +6,6 @@
  * Rewritten by Richard Henderson <rth@tamu.edu> Dec 1996
  * Rewritten again by Rusty Russell, 2002
  */
-#include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/stat.h>
 #include <linux/compiler.h>
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index b72be2f..926adaa 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H

-#include <linux/spinlock.h> /* For preempt_disable() */
+#include <linux/preempt.h>
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/string.h> /* For memset() */
diff --git a/include/linux/scx200_gpio.h b/include/linux/scx200_gpio.h
index 1a82d30..d2b0581 100644
--- a/include/linux/scx200_gpio.h
+++ b/include/linux/scx200_gpio.h
@@ -1,5 +1,3 @@
-#include <linux/spinlock.h>
-
 u32 scx200_gpio_configure(unsigned index, u32 set, u32 clear);

 extern unsigned scx200_gpio_base;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9a5eac5..ea91abe 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -6,7 +6,6 @@

 #ifdef __KERNEL__
 #include <linux/list.h>
-#include <linux/spinlock.h>

 /*
  * Real Time signals may be queued.
diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index cf715a4..58962c5 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -3,7 +3,6 @@

 #ifdef CONFIG_LOCK_KERNEL
 #include <linux/sched.h>
-#include <linux/spinlock.h>

 #define kernel_locked()		(current->lock_depth >= 0)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index e0c5c16..783f182 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -3,7 +3,6 @@

 #include <linux/list.h>
 #include <linux/ktime.h>
-#include <linux/spinlock.h>
 #include <linux/stddef.h>

 struct tvec_t_base_s;

 --
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
