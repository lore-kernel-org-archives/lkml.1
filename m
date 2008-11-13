Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYKMNe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYKMNe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKMNet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:34:49 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:45442 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbYKMNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:34:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAKu2G0lMQWxa/2dsb2JhbACBds49g1c
Date: Thu, 13 Nov 2008 08:34:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [patch 02/17] get_cycles() : x86 HAVE_GET_CYCLES
Message-ID: <20081113133443.GC3604@Krystal>
References: <20081112231551.473569400@polymtl.ca> <20081112232258.559661836@polymtl.ca> <Pine.LNX.4.64.0811130814220.27005@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811130814220.27005@anakin>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:30:50 up 161 days, 18:11,  7 users,  load average: 0.57, 2.36,
	2.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Geert Uytterhoeven (geert@linux-m68k.org) wrote:
> On Wed, 12 Nov 2008, Mathieu Desnoyers wrote:
> > --- linux.trees.git.orig/arch/x86/include/asm/tsc.h	2008-11-12 18:15:25.000000000 -0500
> > +++ linux.trees.git/arch/x86/include/asm/tsc.h	2008-11-12 18:15:28.000000000 -0500
> > @@ -56,6 +56,18 @@ extern void mark_tsc_unstable(char *reas
> >  extern int unsynchronized_tsc(void);
> >  int check_tsc_unstable(void);
> >  
> > +static inline cycles_t get_cycles_rate(void)
> > +{
> > +	if (check_tsc_unstable())
> > +		return 0;
> > +	return tsc_khz;
>                    ^^^
> 
> The comment in Kconfig says:
> 
> | get_cycles_rate() : cycle counter rate, in HZ
>                                              ^^
> 
> So what should it be? Hz or kHz?
> 

HZ, for consistency.

So it becomes :

+static inline cycles_t get_cycles_rate(void)
+{
+	if (check_tsc_unstable())
+		return 0;
+	return (cycles_t)tsc_khz * 1000;
+}
+

Thanks for spotting this, will be integrated in the next release.

As a side-note, I noticed that I used CLOCK_TICK_RATE on MIPS when I
should use mips_hpt_frequency. This too will be fixed in the next
release.

Mathieu

> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
