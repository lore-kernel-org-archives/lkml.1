Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZLIHgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZLIHgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZLIHgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:36:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZLIHgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:36:42 -0500
Date: Wed, 9 Dec 2009 08:36:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
Message-ID: <20091209073632.GD8187@elte.hu>
References: <20091203210913.GA24351@elte.hu>
 <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 3 Dec 2009, Ingo Molnar wrote:
> > 
> > Please pull the latest x86-paravirt-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-paravirt-for-linus
> 
> I _really_ don't like this:
> 
> > -long sys_iopl(struct pt_regs *regs)
> > +asmlinkage long sys_iopl(unsigned int level)
> >  {
> > -	unsigned int level = regs->bx;
> >  	struct thread_struct *t = &current->thread;
> > +	struct pt_regs *regs = task_pt_regs(current);
> 
> I do _not_ want to add any more task_pt_regs() crap, please.
> 
> Why? It's wrong for at least vm86 mode (and from kernel system calls). 
> Maybe we can't get into system calls from vm86 mode, and the kernel 
> hopefully doesn't do those things anyway, but the point is, you chose 
> the wrong way to go.
> 
> The old version that actually passed the stack frame was better. Why 
> pick the inferior version?

Yeah, agreed. I missed that detail.

Jeremy, mind sending a patch that updates this code to use the less 
obfuscated 32-bit version, not the 64-bit version? (a delta patch 
against tip:master would be nice, as there's a fair amount of testing in 
the unification change itself already, which we dont want to discard.)

Thanks,

	Ingo
