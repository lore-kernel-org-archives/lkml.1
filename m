Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZC2LAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZC2LAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZC2LAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:00:04 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:38932 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC2LAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:00:03 -0400
Date: Sun, 29 Mar 2009 12:59:50 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build error in <linux/irq.h>
Message-ID: <20090329105950.GA21370@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/irq.h> relies on <linux/gfp.h> and <linux/topology.h> having been
included previous.  If not, the errors like below will result.

  CC      arch/mips/mti-malta/malta-int.o
In file included from /home/ralf/src/linux/linux-queue/arch/mips/mti-malta/malta-int.c:25:
/home/ralf/src/linux/linux-queue/include/linux/irq.h: In function ‘init_alloc_desc_masks’:
/home/ralf/src/linux/linux-queue/include/linux/irq.h:444: error: implicit declaration of function ‘cpu_to_node’
/home/ralf/src/linux/linux-queue/include/linux/irq.h:446: error: ‘GFP_ATOMIC’ undeclared (first use in this function)
/home/ralf/src/linux/linux-queue/include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
/home/ralf/src/linux/linux-queue/include/linux/irq.h:446: error: for each function it appears in.)
make[3]: *** [arch/mips/mti-malta/malta-int.o] Error 1
make[2]: *** [arch/mips/mti-malta] Error 2
make[1]: *** [sub-make] Error 2

Fixed by including the two missing headers.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/linux/irq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 873e4ac..9c62fbe 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -17,9 +17,11 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
+#include <linux/gfp.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
+#include <linux/topology.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
