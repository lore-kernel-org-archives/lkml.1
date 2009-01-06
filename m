Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZAFMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZAFMST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZAFMSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:18:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZAFMSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:18:10 -0500
Date: Tue, 6 Jan 2009 13:18:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Message-ID: <20090106121802.GA7071@elte.hu>
References: <1231066898.27852.29.camel@jaswinder.satnam> <20090104172114.GA32425@elte.hu> <3f9a31f40901060207j24c580cfl1e8bc71ae486a4b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901060207j24c580cfl1e8bc71ae486a4b9@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Sun, Jan 4, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > the x86-local declarations in smp.h should probably be moved into a
> > separate smp_x86.h file - to avoid such trouble.
> >
> 
> I think we do not need to make any new files only thing we need is to
> rearrange stuff between existing files.
> 
> Currently there is no such protocol, If we follow this logic then it
> will very easy for us to maintain things:
> 
> CONFIG_SMP -> asm/smp.h
> CONFIG_X86_LOCAL_APIC -> asm/apic.h
> CONFIG_X86_IO_APIC -> asm/io_apic.h

yep.

> And if you want then I will give strict instructions so that we will 
> never face these problems again, like :-
> 
> asm/smp.h:
> 
> #ifndef CONFIG_SMP
> #error "Including wrong file, why you need smp.h for Uniprocessor"
> #else
> ...
> #endif
> 
> Similarly for asm/apic.h and asm/io_apic.h

the smp.h change would work, agreed - but it's not really good for things 
like apic.h and io_apic.h - often apic.h is included to pick up init and 
various callback prototypes - which exist on !CONFIG_X96_IO_APIC too.

	Ingo
