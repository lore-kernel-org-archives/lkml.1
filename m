Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbXEJHVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbXEJHVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEJHVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:21:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:44853 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXEJHVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:21:36 -0400
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <a781481a0705092345rf9fdc9cs8495516299a28fae@mail.gmail.com>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
	 <a781481a0705092345rf9fdc9cs8495516299a28fae@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 17:21:17 +1000
Message-Id: <1178781677.14928.221.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So you're saying that this mechanism forces the arch (that really
> wants hard_irq_disable) to _#define_ hard_irq_disable (as a macro),
> and if it implements it as an inline function, for example, then we're
> screwed?

No. The idea is to do like we did for a few other things already
(according to Linus request in fact), which is to write

static inline void hard_irq_disable(void)
{
	.../...
}
#define hard_irq_disable hard_irq_disable

This is nicer than having an ARCH_HAS_xxx

> 1. Introduce some CONFIG_WANTS_HARD_IRQ_DISABLE that is #defined (or
> left undefined) by the arch/.../defconfig (depending upon whether or
> not that arch implements a hard_irq_disable() for itself or not)
>
> 2. Then pull-in that code into include/linux/interrupt.h somehow
> (through some known / fixed header file, or through asm/system.h, or
> anyhow -- it doesn't really matter)
> 
> 3. And:
> 
> #ifndef CONFIG_WANTS_HARD_IRQ_DISABLE
> #define hard_irq_disable() do { } while(0)
> #endif

Well, last time I tried that, Linus NACKed it in favor of what I
described above.

> We don't need to standardize on some particular arch-specific header
> filename in this case.

True, that's my main problem here. Though really only the archs who
actually implement something special here need to be careful.

Ben.

