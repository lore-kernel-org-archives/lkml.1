Return-Path: <linux-kernel-owner+w=401wt.eu-S1763819AbXFAUQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763819AbXFAUQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762889AbXFAUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:16:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:42260 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762558AbXFAUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=G7YxRRBTTF2ti1lAByb7ZozPVhmFf766m1SxsXAv+c2YnW3QMVFe1asZXaNS6Jc0c9jd8NDxC6jJy2QmzAk2iQ68j/ay0j9A/GppNW6N3XberrRkM6fHcQPews1YK75GuCcklRwTrGwO8o5LVaoXbkmix/TyP0BDs/ALmrbtNtI=
Date: Sat, 2 Jun 2007 00:19:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH] Remove capability.h from mm.h
Message-ID: <20070601201921.GA5533@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, I forgot to remove capability.h from mm.h while removing sched.h!
This patch remedies that, because the only inline function which was
using CAP_something was made out of line.

Cross-compile tested without regressions on:

	all powerpc defconfigs
	all mips defconfigs
	all m68k defconfigs
	all arm defconfigs
	all ia64 defconfigs

	alpha alpha-allnoconfig alpha-defconfig alpha-up
	arm
	i386 i386-allnoconfig i386-defconfig i386-up
	ia64 ia64-allnoconfig ia64-defconfig ia64-up
	m68k
	mips
	parisc parisc-allnoconfig parisc-defconfig parisc-up
	powerpc powerpc-up
	s390 s390-allnoconfig s390-defconfig s390-up
	sparc sparc-allnoconfig sparc-defconfig sparc-up
	sparc64 sparc64-allnoconfig sparc64-defconfig sparc64-up
	um-x86_64
	x86_64 x86_64-allnoconfig x86_64-defconfig x86_64-up

as well as my two usual configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/pci/pci-sysfs.c |    2 +-
 drivers/pci/proc.c      |    2 +-
 fs/gfs2/eaops.c         |    1 +
 include/linux/mm.h      |    1 -
 kernel/time/ntp.c       |    2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -20,7 +20,7 @@
 #include <linux/stat.h>
 #include <linux/topology.h>
 #include <linux/mm.h>
-
+#include <linux/capability.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-
+#include <linux/capability.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include "pci.h"
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/capability.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2,7 +2,6 @@
 #define _LINUX_MM_H
 
 #include <linux/errno.h>
-#include <linux/capability.h>
 
 #ifdef __KERNEL__
 
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -13,7 +13,7 @@
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
-
+#include <linux/capability.h>
 #include <asm/div64.h>
 #include <asm/timex.h>
 

