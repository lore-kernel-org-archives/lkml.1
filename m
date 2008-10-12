Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbYJLEej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbYJLEej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 00:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYJLEec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 00:34:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33352 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbYJLEeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 00:34:31 -0400
Date: Sun, 12 Oct 2008 07:33:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Manfred Spraul <manfred@colorfullife.com>, takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] m32r/kernel/smpboot.c must #include <linux/cpu.h>
Message-ID: <20081012043335.GD31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit e545a6140b698b2494daf0b32107bdcc5e90139
(kernel/cpu.c: create a CPU_STARTING cpu_chain notifier):

<--  snip  -->

...
  CC      arch/m32r/kernel/smpboot.o
arch/m32r/kernel/smpboot.c: In function 'smp_online':
arch/m32r/kernel/smpboot.c:501: error: implicit declaration of function 'notify_cpu_starting'
make[2]: *** [arch/m32r/kernel/smpboot.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index fc29948..938f65e 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -48,6 +48,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>

