Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXC0Qwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXC0Qwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXC0Qwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:52:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36076 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933251AbXC0Qwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:52:36 -0400
Date: Tue, 27 Mar 2007 18:52:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fix arch/i386/kernel/marker.c compilation
Message-ID: <20070327165240.GD16477@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 08:57:06PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc4-mm1:
>...
> +move-die-notifier-handling-to-common-code.patch
>...
>  Misc
>...


This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/i386/kernel/marker.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c: In function 'mark_notifier':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:44: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:44: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:47: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:48: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c: In function 'marker_optimized_set_enable':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:69: error: implicit declaration of function 'register_die_notifier'
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:87: error: implicit declaration of function 'unregister_die_notifier'
make[2]: *** [arch/i386/kernel/marker.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c.old	2007-03-27 18:46:49.000000000 +0200
+++ linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c	2007-03-27 18:47:14.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/marker.h>
+#include <linux/kdebug.h>
 #include <asm/cacheflush.h>
 #include <asm/kdebug.h>
 

