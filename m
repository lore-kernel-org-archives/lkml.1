Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbYJWOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbYJWOha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYJWOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:37:10 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:47533 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYJWOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:37:09 -0400
Date: Thu, 23 Oct 2008 16:37:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
In-Reply-To: <49008D12.5090204@gmail.com>
Message-ID: <Pine.LNX.4.64.0810231635440.18978@anakin>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> 
 <20081023121145.GB27984@x200.localdomain>  <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
 <49008D12.5090204@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-1462764117-1224772621=:18978"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-1462764117-1224772621=:18978
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 23 Oct 2008, Frederic Weisbecker wrote:
> Frédéric Weisbecker wrote:
> > 2008/10/23 Frédéric Weisbecker <fweisbec@gmail.com>:
> >> 2008/10/23 Alexey Dobriyan <adobriyan@gmail.com>:
> >>> On alpha-smp-n-debug-y:
> >>>
> >>> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> >>> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> >>> kernel/trace/trace.c: In function 'tracing_cpumask_write':
> >>> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
> >>> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
> >>> kernel/trace/trace.c: In function 'trace_die_handler':
> >>> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
> >>>
> >>> This has something with config dependencies, because adding include doesn't fix it.
> >>>
> >> A lot of arch have an asm/irqflags.h but not alpha.
> >> In linux/irqflags, raw_local_irq_* functions are defined to be
> >> local_irq_* function if they don't support
> >> CONFIG_TRACE_IRQFLAGS_SUPPORT.
> >> It seems the error is here, alpha may turn this option off.
> >>
> > 
> > Hmm no actually your CONFIG_TRACE_IRFLAGS_SUPPORT is not set.
> > So that's because the linux/irqflags.h is not included in the
> > asm/system.h on alpha (other archs do).
> > 
> 
> Does this patch correct the issue?
> It applies on last -tip
> ---
> 
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: [PATCH] alpha: include irqflags.h to enable use of tracing
> 
> asm/system.h should include linux/irqflags.h to enable the use of tracing
> which needs raw_local_irq_* functions.

If kernel/trace/trace.c calls irqs_disabled_flags(), it should include
the include that defines irqs_disabled_flags(). You should not add it to
some other random include.

It's also happening on m68k:
http://kisskb.ellerman.id.au/kisskb/buildresult/50641/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-1462764117-1224772621=:18978--
