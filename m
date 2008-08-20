Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYHTKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYHTKri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYHTKr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:47:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40123 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYHTKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:47:29 -0400
Date: Wed, 20 Aug 2008 12:47:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: update recordmount.pl arch changes
Message-ID: <20080820104711.GG2816@elte.hu>
References: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com> <20080815154234.GE27955@elte.hu> <alpine.DEB.1.10.0808191430010.28232@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808191430010.28232@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 15 Aug 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > I'm trying to keep all the arch changes in recordmcount.pl in one 
> > > place. I moved your code into that area, by adding the flags to the 
> > > commands that were passed in.
> > > 
> > > Does this change still work for you when compiling i386 on a x86_64 
> > > box?
> > 
> > actually, i thought of this as a quick hack to let -tip testing 
> > continue. Dont we have all the proper information available in kbuild 
> > and should just pass that to scripts/recordmcount.pl when called - like 
> > we pass in things like OBJDUMP which might have cross-build overrides, 
> > etc.
> 
> Ingo,
> 
> Could you use my updated patch. I know it is still just a work around, but 
> your update broke my build.  I use distcc which passes in "distcc" as gcc. 
> My distcc is self built and is not the same as the distribution gcc.
> 
> Ie, you have:
> 
> if ($arch eq "x86_64") {
>   $ld = "ld -m elf_x86_64";
>   $objdump = "objdump -M x86-64";
>   $objcopy = "objcopy -O elf64-x86-64";
>   $cc = "gcc -m64";
> }
> 
> Where the $cc = "gcc" is not compatible on my system. I end up with a bad 
> build that causes ftrace to fail on bootup.

sure - applied to tip/tracing/ftrace.

	Ingo
