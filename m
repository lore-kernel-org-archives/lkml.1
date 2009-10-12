Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZJLUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZJLUxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJLUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:53:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbZJLUxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:53:07 -0400
Date: Mon, 12 Oct 2009 22:52:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
	helper
Message-ID: <20091012205208.GE17163@elte.hu>
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org> <4ACB93F8.5010900@goop.org> <20091007163521.GA17998@wavehammer.waldi.eu.org> <4ACD3346.3010307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACD3346.3010307@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/07/09 09:35, Bastian Blank wrote:
> > On Tue, Oct 06, 2009 at 12:01:12PM -0700, Jeremy Fitzhardinge wrote:
> >   
> >> On 10/05/09 20:30, Bastian Blank wrote:
> >>     
> >>> The original version saves ecx, but not edx. Both are official
> >>> caller-saved registers.
> >>>       
> >> Hm.  It doesn't save edx because that can be half of a 64-bit return
> >> value, and in general both eax and edx are marked clobbered.
> >>     
> > Then it will be also wrong for functions returning void. They may
> > clobber eax but never set it to something correct.
> >   
> 
> The asm is marked as clobbering eax/edx, so the compiler knows it can't
> rely on them being preserved.  void functions are not expected to
> preserve them either, so it all works out (or if they are, the compiler
> will do the right thing).
> 
> Or did you have something else in mind?
> 
> 
> >>                                                               Except one
> >> place; does the patch below help?
> >>     
> > Don't you need to remove the complete wrapper setup to get a correct
> > result? (And type safety.)
> >   
> 
> Which wrapper?  Do you mean the callee-save function stuff?  Or
> something else?
> 
> It compiles cleanly for me and appears to work.  Does it solve the
> problem for you?
> 
> >>> Well, my call stack say something different. It crashs during early
> >>> startup without a console. The modifications to the function pointers is
> >>> done much later.
> >>>       
> >> You're right.  But you're holding out on me; can I see your backtrace? 
> >>     
> > Well, I'm traveling and it needs some time to recreate a broken kernel.
> >
> >   
> >> And the disassembly of the troublesome code (both the Xen function and
> >> the calling function)?
> >>     
> > That is easy.
> >   
> 
> OK, I see, thanks.

ping - any update about this fix? Since it fixes a real crash it would 
be nice to fix this for .32.

	Ingo
