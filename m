Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZAaWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZAaWUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 17:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZAaWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 17:19:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZAaWTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 17:19:55 -0500
Date: Sat, 31 Jan 2009 23:19:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090131221939.GD29364@elte.hu>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop> <1233422632.4787.31.camel@laptop> <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com> <1233425327.4787.35.camel@laptop> <20090131212106.6e2e05b0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131212106.6e2e05b0@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sat, 31 Jan 2009 19:08:47 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
> > > 
> > > And answering an earlier question, this happens only on i386 and only
> > > with 4K stacks because x86_64 dosn't have a separate softirq stack,
> > > so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
> > 
> > What do the other 30 odd architectures that Linux supports do? Is i386 
> > 4k really the _only_ with separate softirq stacks?
> 
> x86-64 and some of the other platforms could do with IRQ stacks but that 
> is another story.

64-bit x86 already has IRQ stacks [16K large, per CPU], separate from the 
8K syscall/process stack.

The question here is that on 64-bit hardirqs and softirqs share the same 
stack (it's large enough). On 32-bit we have them separated.

	Ingo
