Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYEQVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYEQVlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbYEQVkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:40:53 -0400
Received: from www.tglx.de ([62.245.132.106]:37572 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbYEQVkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:40:52 -0400
Date: Sat, 17 May 2008 23:40:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
In-Reply-To: <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Maciej W. Rozycki wrote:
> On Sat, 17 May 2008, Tom Spink wrote:
> 
> > static inline unsigned int get_nmi_count(int cpu)
> > {
> > #ifdef CONFIG_X86_64
> >         return cpu_pda(cpu)->__nmi_count;
> > #else
> >         return nmi_count(cpu);
> > #endif
> > }
> > 
> > I know it introduces a lot of these conditionals, but at least there
> > is one place to look for the get_nmi_count function, instead of
> > searching for all variants of the function.
> 
>  Well, I suppose some header should provide a definition like:
> 
> #ifdef CONFIG_X86_64
> #define cpu_x86_64 1
> #else
> #define cpu_x86_64 0
> #endif
> 
> and the you can remove the horrible #ifdef clutter and make the quoted 
> function look like:
> 
> static inline unsigned int get_nmi_count(int cpu)
> {
> 	return cpu_x86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
> }
> 
> Much better -- isn't it?

Definitely, but we should do it at the Kconfig level which allows us
to have integer defines as well, so we end up with something like:

static inline unsigned int get_nmi_count(int cpu)
{
      return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
}

That way we do not even have to think about which header to select for
the include and the association of the selector is stronger than the
cpu_x86_64 one, isn't it ?

Thanks,
	tglx
