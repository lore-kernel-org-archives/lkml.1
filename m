Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbXKSTPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbXKSTPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXKSTPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:15:09 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:57310 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbXKSTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:15:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAtvQUdMROHU/2dsb2JhbACBWA
Date: Mon, 19 Nov 2007 14:15:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Message-ID: <20071119191504.GA2288@Krystal>
References: <20071113185800.436425570@polymtl.ca> <200711152206.07519.rusty@rustcorp.com.au> <20071116140334.GA14930@Krystal> <200711191011.18634.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200711191011.18634.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:11:00 up 16 days, 16 min,  5 users,  load average: 2.94, 1.36,
	1.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
[...]
> > +++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-16
> > 08:56:22.000000000 -0500 @@ -0,0 +1,143 @@
> > +/*
> > + * Immediate Value - x86 architecture specific code.
> 
> This is now almost entirely generic code, but I suppose we can let the next
> architecture hoist it out.
> 

Almost.. actually, I have to call those architecture specific primitives :
- text_poke : a memcpy that copies to write protected memory (disables the
  WP bit)
- sync_core : synchronize the core, only defined on x86

I'll also have to add a flush_icache_range to support powerpc correctly,
but this one turns out to be implemented on each architecture and
therefore is not a problem.

So I guess the proper way to do this would be to add :

#define text_poke       memcpy
#define text_poke_early text_poke
#define sync_core()

to asm-$ARCH/cacheflush.h for each architecture we add support for
HAS_IMMEDIATE ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
