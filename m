Return-Path: <linux-kernel-owner+w=401wt.eu-S933935AbXC1MLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935AbXC1MLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXC1MLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:11:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36841 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933935AbXC1MLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:11:38 -0400
Date: Wed, 28 Mar 2007 14:11:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: [-mm patch] no longer #include <asm/kdebug.h>
Message-ID: <20070328121136.GP16477@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070327165240.GD16477@stusta.de> <20070327171150.GA24349@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070327171150.GA24349@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 01:11:50PM -0400, Mathieu Desnoyers wrote:

> Hi Adrian,
> 
> Since kdebug.h seems to have moved from asm/ to linux/ in Andrew's tree, I
> guess the #include <asm/kdebug.h> should be removed ? linux/kdebug.h
> already includes asm/kdebug.h.

Agreed, additional patch to remove all #include <asm/kdebug.h>'s is
below.

> Mathieu

cu
Adrian


<--  snip  -->


Include the new linux/kdebug.h instead of asm/kdebug.h.

Simply remove the asm/kdebug.h include if both had been included.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/marker.c         |    1 -
 arch/s390/kernel/dis.c            |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c.old	2007-03-27 23:27:56.000000000 +0200
+++ linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c	2007-03-27 23:28:04.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/marker.h>
 #include <linux/kdebug.h>
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
 
 #define BREAKPOINT_INSTRUCTION  0xcc
 #define BREAKPOINT_INS_LEN 1
--- linux-2.6.21-rc5-mm2/arch/s390/kernel/dis.c.old	2007-03-27 23:28:12.000000000 +0200
+++ linux-2.6.21-rc5-mm2/arch/s390/kernel/dis.c	2007-03-27 23:28:25.000000000 +0200
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/reboot.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -33,7 +34,6 @@
 #include <asm/s390_ext.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
-#include <asm/kdebug.h>
 
 #ifndef CONFIG_64BIT
 #define ONELONG "%08lx: "
--- linux-2.6.21-rc5-mm2/drivers/char/ipmi/ipmi_watchdog.c.old	2007-03-27 23:28:34.000000000 +0200
+++ linux-2.6.21-rc5-mm2/drivers/char/ipmi/ipmi_watchdog.c	2007-03-27 23:28:56.000000000 +0200
@@ -61,7 +61,6 @@
    how it will work.  So in the unlikely event that another
    architecture supports this, we can figure out a good generic
    mechanism for it at that time. */
-#include <asm/kdebug.h>
 #define HAVE_DIE_NMI_POST
 #endif
 

