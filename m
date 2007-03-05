Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbXCECBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbXCECBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXCEBru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:50 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49905 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712AbXCEBrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:31 -0500
Date: Mon, 5 Mar 2007 02:47:33 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] arch/i386/kernel/vmi.c must #include <asm/kmap_types.h>
Message-ID: <20070305014733.GO3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
> +vmi-fix-highpte.patch
>...
>  2.6.21 queue
>...

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/i386/kernel/vmi.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c: In function 'vmi_map_pt_hook':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: 'KM_PTE0' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: 'KM_PTE1' undeclared (first use in this function)
make[2]: *** [arch/i386/kernel/vmi.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c.old	2007-03-04 16:44:14.000000000 +0100
+++ linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c	2007-03-04 16:44:27.000000000 +0100
@@ -35,6 +35,7 @@
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
+#include <asm/kmap_types.h>
 
 /* Convenient for calling VMI functions indirectly in the ROM */
 typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);

