Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZAKPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZAKPHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZAKPHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:07:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZAKPHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:07:34 -0500
Date: Sun, 11 Jan 2009 16:07:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090111150711.GA32262@elte.hu>
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu> <20090111042857.GA7195@elte.hu> <4969AF5E.7020809@kernel.org> <20090111145406.GB13453@elte.hu> <20090111150404.GA31464@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111150404.GA31464@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> > > +++ b/include/linux/random.h
> > > @@ -10,6 +10,10 @@
> > >  #include <linux/ioctl.h>
> > >  #include <linux/irqnr.h>
> > >  
> > > +#ifdef CONFIG_GENERIC_HARDIRQS
> > > +#include <linux/irq.h>
> > > +#endif
> 
> fails CONFIG_HEADERS_CHECK=y:
> 
> /home/mingo/linux/linux/usr/include/linux/random.h:14:
>  included file 'linux/irq.h' is not exported

replaced it with the patch below instead. Hopefully that's enough.

	Ingo

--------------------->
>From d178a1eb5c034df1f74a2b67bf311afa5d6b8e95 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Sun, 11 Jan 2009 00:35:42 -0800
Subject: [PATCH] sparseirq: fix build with unknown irq_desc struct

Ingo Molnar wrote:
>
> tip/kernel/fork.c: In function 'copy_signal':
> tip/kernel/fork.c:825: warning: unused variable 'ret'
> tip/drivers/char/random.c: In function 'get_timer_rand_state':
> tip/drivers/char/random.c:584: error: dereferencing pointer to incomplete type
> tip/drivers/char/random.c: In function 'set_timer_rand_state':
> tip/drivers/char/random.c:594: error: dereferencing pointer to incomplete type
> make[3]: *** [drivers/char/random.o] Error 1

irq_desc is defined in linux/irq.h, so include it in the genirq case.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/random.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a778918..7c43ae7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -241,6 +241,10 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+# include <linux/irq.h>
+#endif
+
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
