Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZI3UVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZI3UVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZI3UVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:21:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZI3UVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:21:47 -0400
Date: Wed, 30 Sep 2009 13:20:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <4AC3BC89.2050404@gmail.com>
Message-ID: <alpine.LFD.2.01.0909301320300.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <20090930193204.GA16350@elte.hu>
 <4AC3BC89.2050404@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Eric Dumazet wrote:
> > +#define cmpxchg64(ptr, o, n)					\
> > +({								\
> > +	__typeof__(*(ptr)) __ret;				\
> > +	__typeof__(*(ptr)) __old = (o);				\
> > +	__typeof__(*(ptr)) __new = (n);				\
> > +	alternative_io("call cmpxchg8b_emu",			\
> > +			"lock; cmpxchg8b (%%esi)" ,		\
> > +		       X86_FEATURE_CX8,				\
> > +		       "=A" (__ret),				\
> > +		       "S" ((ptr)), "0" (__old),		\
> > +		       "b" ((unsigned int)__new),		\
> > +		       "c" ((unsigned int)(__new>>32)));	\
> 
> probably a "memory" clobber is needed, alternative_io() doesnt provide it.

Yeah, good catch.

			Linus
