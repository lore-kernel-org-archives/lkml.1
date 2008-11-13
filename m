Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYKMHPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYKMHPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYKMHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:15:21 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:47745 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYKMHPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:15:15 -0500
Date: Thu, 13 Nov 2008 08:15:08 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [patch 02/17] get_cycles() : x86 HAVE_GET_CYCLES
In-Reply-To: <20081112232258.559661836@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0811130814220.27005@anakin>
References: <20081112231551.473569400@polymtl.ca> <20081112232258.559661836@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Mathieu Desnoyers wrote:
> --- linux.trees.git.orig/arch/x86/include/asm/tsc.h	2008-11-12 18:15:25.000000000 -0500
> +++ linux.trees.git/arch/x86/include/asm/tsc.h	2008-11-12 18:15:28.000000000 -0500
> @@ -56,6 +56,18 @@ extern void mark_tsc_unstable(char *reas
>  extern int unsynchronized_tsc(void);
>  int check_tsc_unstable(void);
>  
> +static inline cycles_t get_cycles_rate(void)
> +{
> +	if (check_tsc_unstable())
> +		return 0;
> +	return tsc_khz;
                   ^^^

The comment in Kconfig says:

| get_cycles_rate() : cycle counter rate, in HZ
                                             ^^

So what should it be? Hz or kHz?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
