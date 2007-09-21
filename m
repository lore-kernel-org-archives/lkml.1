Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXIUN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXIUN40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXIUN4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:56:18 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53734 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbXIUN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:56:17 -0400
Date: Fri, 21 Sep 2007 09:51:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.23-rc6-mm1 sparc build error
Message-ID: <20070921135112.GI13129@Krystal>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070918205403.GA13650@Krystal> <20070918140508.e2c56212.akpm@linux-foundation.org> <Pine.LNX.4.60.0709201418000.5039@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0709201418000.5039@poirot.grange>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:50:51 up 53 days, 14:09,  4 users,  load average: 0.56, 0.56, 0.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Guennadi Liakhovetski (g.liakhovetski@gmx.de) wrote:
> Provide {enable,disable}_irq_wakeup dummies for undefined 
> CONFIG_GENERIC_HARDIRQS case. Completely untested, as I don't even have 
> cross-compilers for platforms without CONFIG_GENERIC_HARDIRQS.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 

It builds fine now.

Tested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> 
> On Tue, 18 Sep 2007, Andrew Morton wrote:
> 
> > On Tue, 18 Sep 2007 16:54:03 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > I got the following error when building 2.6.23-rc6-mm1 on sparc:
> > > 
> > > 
> > >   /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/bin/sparc-unknown-linux-gnu-gcc -Wp,-MD,drivers/serial/.serial_core.o.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/lib/gcc/sparc-unknown-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h  -I/home/compudj/git/linux-2.6-lttng/drivers/serial -Idrivers/serial -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7 -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(serial_core)"  -D"KBUILD_MODNAME=KBUILD_STR(serial_core)" -c -o drivers/serial/.tmp_serial_core.o /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c
> > > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c: In function 'uart_suspend_port':
> > > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c:1980: error: implicit declaration of function 'enable_irq_wake'
> > > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c: In function 'uart_resume_port':
> > > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c:2035: error: implicit declaration of function 'disable_irq_wake'
> > 
> > hm, I wonder why I didn't hit that.
> > 
> > enable_irq_wake() was added by wake-up-from-a-serial-port.patch
> > 
> > I note that git-input adds a call too, and might have a problem
> > with !CONFIG_GENERIC_HARDIRQS.
> > 
> > Not sure what the best fix is here.  We could sprinkle ifdefs all
> > over the code, or just add the suitable empty stubs for enable_irq_wake(),
> > etc.
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 5323f62..ecade41 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -205,6 +205,9 @@ static inline int disable_irq_wake(unsigned int irq)
>  						enable_irq(irq)
>  # endif
>  
> +#define enable_irq_wake(irq) ({ (void)(irq); 0; })
> +#define disable_irq_wake(irq) ({ (void)(irq); 0; })
> +
>  #endif /* CONFIG_GENERIC_HARDIRQS */
>  
>  #ifndef __ARCH_SET_SOFTIRQ_PENDING

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
