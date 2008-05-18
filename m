Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYERJJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYERJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 05:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYERJJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 05:09:48 -0400
Received: from www.tglx.de ([62.245.132.106]:60924 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYERJJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 05:09:48 -0400
Date: Sun, 18 May 2008 11:09:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
In-Reply-To: <482FD9F2.8080204@goop.org>
Message-ID: <alpine.LFD.1.10.0805181108420.18798@apollo.tec.linutronix.de>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Jeremy Fitzhardinge wrote:

> Thomas Gleixner wrote:
> > Definitely, but we should do it at the Kconfig level which allows us
> > to have integer defines as well, so we end up with something like:
> > 
> > static inline unsigned int get_nmi_count(int cpu)
> > {
> >       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
> > }
> >   
> 
> Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined it
> doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1, but we'd
> need to change all the #ifdef CONFIG_* to #if CONFIG_*...

You can have int type CONFIG_ which is always expanded. We have to add
one of those though.

Thanks,
	tglx
