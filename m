Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZAKIgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZAKIgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZAKIg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:36:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:34756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZAKIg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:36:29 -0500
Message-ID: <4969AF5E.7020809@kernel.org>
Date: Sun, 11 Jan 2009 00:35:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu> <20090111042857.GA7195@elte.hu>
In-Reply-To: <20090111042857.GA7195@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Yinghai, the crossbuild to Alpha fails with:
> 
> /home/mingo/tip/kernel/fork.c: In function 'copy_signal':
> /home/mingo/tip/kernel/fork.c:825: warning: unused variable 'ret'
> /home/mingo/tip/drivers/char/random.c: In function 'get_timer_rand_state':
> /home/mingo/tip/drivers/char/random.c:584: error: dereferencing pointer to incomplete type
> /home/mingo/tip/drivers/char/random.c: In function 'set_timer_rand_state':
> /home/mingo/tip/drivers/char/random.c:594: error: dereferencing pointer to incomplete type
> make[3]: *** [drivers/char/random.o] Error 1
> 

please check

[PATCH] sparseirq: fix compiling with unknown irq_desc struct

Impact: fix compiling

irq_desc is defined in linux/irq.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/include/linux/random.h b/include/linux/random.h
index 407ea36..a27bf17 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -10,6 +10,10 @@
 #include <linux/ioctl.h>
 #include <linux/irqnr.h>
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
+
 /* ioctl()'s for the random number generator */
 
 /* Get the entropy count. */
