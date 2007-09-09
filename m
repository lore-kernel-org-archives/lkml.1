Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXIIUYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXIIUYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbXIIUYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:24:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60705 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755101AbXIIUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:24:42 -0400
Date: Sun, 9 Sep 2007 22:24:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       rth@twiddle.net
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] alpha bitops.h must #include <asm/barrier.h>
Message-ID: <20070909202448.GL3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +alpha-lock-bitops.patch
>...
>  various stuff
>...

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/alpha/kernel/asm-offsets.s
In file included from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/bitops.h:17,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/kernel.h:15,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:50,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/alpha/kernel/asm-offsets.c:9:
include2/asm/bitops.h: In function 'clear_bit_unlock':
include2/asm/bitops.h:75: error: implicit declaration of function 'smp_mb'
make[2]: *** [arch/alpha/kernel/asm-offsets.s] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6df784c9aa4ba1ff2062b63e733c645e8b1e5203 
diff --git a/include/asm-alpha/bitops.h b/include/asm-alpha/bitops.h
index ffec8a8..381b4f5 100644
--- a/include/asm-alpha/bitops.h
+++ b/include/asm-alpha/bitops.h
@@ -2,6 +2,7 @@
 #define _ALPHA_BITOPS_H
 
 #include <asm/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * Copyright 1994, Linus Torvalds.

