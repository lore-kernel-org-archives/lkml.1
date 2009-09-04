Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZIDGje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZIDGje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZIDGje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:39:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZIDGjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:39:33 -0400
Date: Fri, 4 Sep 2009 08:39:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, petkovbb@googlemail.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset
	registers
Message-ID: <20090904063904.GA29829@elte.hu>
References: <20090831073429.GA26596@liondog.tnic> <1251705011-18636-1-git-send-email-petkovbb@gmail.com> <20090903155539.ecd64bcd.akpm@linux-foundation.org> <4AA049F2.5000403@zytor.com> <20090903161426.cc441294.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903161426.cc441294.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 03 Sep 2009 15:57:54 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 09/03/2009 03:55 PM, Andrew Morton wrote:
> > > On Mon, 31 Aug 2009 09:50:09 +0200
> > > Borislav Petkov <petkovbb@googlemail.com> wrote:
> > > 
> > >> +.macro op_safe_regs op:req
> > > 
> > > Using
> > > 
> > > GNU assembler 2.16.1
> > > 
> > > I get
> > > 
> > > arch/x86/lib/msr-reg.S: Assembler messages:
> > > arch/x86/lib/msr-reg.S:53: Error: Bad macro parameter list
> > > arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
> > > arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic
> > > 
> > > this:
> > > 
> > > diff -puN arch/x86/lib/msr-reg.S~a arch/x86/lib/msr-reg.S
> > > --- a/arch/x86/lib/msr-reg.S~a
> > > +++ a/arch/x86/lib/msr-reg.S
> > > @@ -50,7 +50,7 @@ ENDPROC(native_\op\()_safe_regs)
> > >  
> > >  #else /* X86_32 */
> > >  
> > > -.macro op_safe_regs op:req
> > > +.macro op_safe_regs op
> > >  ENTRY(native_\op\()_safe_regs)
> > >         CFI_STARTPROC
> > >         pushl_cfi %ebx
> > > 
> > > 
> > > fixed it.
> > 
> > Yup, already fixed in -tip.
> > 
> 
> <looks>
> 
> Three days ago.  linux-next is still busted.

No, the 32-bit ancient-binutils bug you have hit here was found and 
fixed ~8 hours ago, by me, and i pushed the fix out immediately. 
(and this happened before you wrote this mail and the fix was posted 
to lkml as well.)

> I want my five minutes back.

I too want my five minutes back that i spent researching commit logs 
and writing this email ;-)

Btw., we could save much more if we avoided this whole 'break the 
kernel then fix it' infinite loop that kernel development is 
ultimately about ;-)

	Ingo
