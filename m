Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXF1Ryx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXF1Ryx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765162AbXF1Ryk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:54:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765129AbXF1Ryi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:54:38 -0400
Date: Thu, 28 Jun 2007 10:54:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070628105431.18092084.akpm@linux-foundation.org>
In-Reply-To: <4683A4D1.3000703@googlemail.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<4683A4D1.3000703@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 14:08:49 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> >
> >   
> 
> Compile error here.
> 
> ...
> 
> Kernel: arch/i386/boot/bzImage is ready (#1)
> ERROR: "check_signature" [drivers/input/misc/wistron_btns.ko] undefined!
> ERROR: "check_signature" [drivers/block/xd.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 

grrr.

--- a/lib/Makefile~uninline-check_signature-fix
+++ a/lib/Makefile
@@ -5,8 +5,7 @@
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 check_signature.o
+	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
 
 lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -14,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o
+	 bust_spinlocks.o hexdump.o check_signature.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
_

