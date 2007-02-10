Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXBJLlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXBJLlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXBJLlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:41:35 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:23360 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXBJLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:41:34 -0500
Date: Sat, 10 Feb 2007 12:40:26 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch] iomap s390 build fix
Message-ID: <20070210114026.GA12642@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

9ac7849e35f705830f7b016ff272b0ff1f7ff759 breaks s390, we don't
have any PCI devices...

lib/built-in.o(.text+0xcdc): In function `devm_ioport_map_release':
: undefined reference to `ioport_unmap'
lib/built-in.o(.text+0xd64): In function `devm_ioport_map':
: undefined reference to `ioport_map'
lib/built-in.o(.text+0xdd2): In function `devm_ioport_unmap':
: undefined reference to `ioport_unmap'
lib/built-in.o(.text+0x10a2): In function `pcim_iomap_release':
: undefined reference to `pci_iounmap'
lib/built-in.o(.text+0x11bc): In function `pcim_iomap':
: undefined reference to `pci_iomap'
lib/built-in.o(.text+0x121e): In function `pcim_iounmap':
: undefined reference to `pci_iounmap'
lib/built-in.o(.text+0x136c): In function `pcim_iomap_regions':
: undefined reference to `pci_request_region'
lib/built-in.o(.text+0x13b4): In function `pcim_iomap_regions':
: undefined reference to `pci_release_region'
lib/built-in.o(.text+0x13e4): In function `pcim_iomap_regions':
: undefined reference to `pci_release_region'
make: *** [.tmp_vmlinux1] Error 1

Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile
+++ linux-2.6/lib/Makefile
@@ -12,13 +12,14 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
-obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o iomap.o
+obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
+obj-$(CONFIG_PCI) += iomap.o
 obj-$(CONFIG_IOMAP_COPY) += iomap_copy.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
