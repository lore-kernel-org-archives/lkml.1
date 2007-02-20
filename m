Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXBTAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXBTAIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXBTAI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:28 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36167 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750986AbXBTAIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:21 -0500
Date: Tue, 20 Feb 2007 01:08:20 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] include/linux/ptrace.h must #include <linux/errno.h>
Message-ID: <20070220000820.GN13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +utrace-utrace-ptrace-compat.patch
>...
>  utrace tree
>...


This patch fixes the following compile error:

<--  snip  -->

...
  CC      drivers/net/wan/lmc/lmc_media.o
In file included from /home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/drivers/net/wan/lmc/lmc_media.c:6:
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/ptrace.h: In function 'ptrace_do_wait':
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/ptrace.h:238: error: 'ECHILD' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/ptrace.h:238: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/ptrace.h:238: error: for each function it appears in.)
make[5]: *** [drivers/net/wan/lmc/lmc_media.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/include/linux/ptrace.h.old	2007-02-19 22:59:04.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/ptrace.h	2007-02-19 22:59:24.000000000 +0100
@@ -51,6 +51,7 @@
 #ifdef __KERNEL__
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/errno.h>
 struct task_struct;
 struct siginfo;
 struct rusage;

