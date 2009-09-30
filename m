Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZI3Sxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZI3Sxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZI3Sx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:53:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbZI3Sx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:53:28 -0400
Date: Wed, 30 Sep 2009 20:53:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930185315.GA9716@elte.hu>
References: <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 30 Sep 2009, Eric Dumazet wrote:
> > 
> > lock; cmpxchg8b (%%esi)
> > 
> > gives 4 bytes opcode : f0 0f c7 0e
> > Because alternative (call cmpxchg8b_emu) uses 5 bytes, a nop will be added.
> > 
> > Choosing ".byte 0xf0, 0x0f, 0xc7, 0x4e, 0x00"  aka "lock cmpxchg8b 0x0(%esi)" is a litle bit better ?
> 
> And if you want to be really clever, you would want to handle the 
> non-SMP case too, where you have just "cmpxchgb (%%esi)" (three bytes) 
> without the lock prefix.
> 
> However, at this point I think Arjan's patch is already way superior 
> to what we have now (feel free to take a look at what we generate on 
> 32-bit without PAE today - just have a barf-bag handy), so all I'd 
> really want is a few "tested-by"s to make me feel happier about it, 
> and a few more people looking at the emulation routine to all say "ok, 
> looks sane, ACK".
> 
> And at that point we can then either make "cmpxchg()" just do the 
> 8-byte case natively, or just take your patch to change sched_clock.c 
> to now use the no-longer-entirely-disgusting cmpxchg64().
> 
> Ingo - I suspect both those patches should just go through you. You do 
> both x86 and scheduler, so I'll happily pull the end result.

Yeah - working on it - just got back from a trip. It's two risky patches 
and if that place breaks everyone will be affected so i'll probably send 
the pull request tomorrow.

	Ingo
