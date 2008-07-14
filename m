Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYGNPNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYGNPNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYGNPND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:13:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYGNPNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:13:01 -0400
Date: Mon, 14 Jul 2008 17:12:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
Message-ID: <20080714151247.GA27145@elte.hu>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008, Ingo Molnar wrote:
> >  
> > +config ILLEGAL_POINTER_VALUE
> > +       hex
> > +       default 0 if X86_32
> > +       default 0xffffc10000000000 if X86_64
> 
> This looks like a singularly bad pointer value on x86-64.
> 
> Why not pick something that is *guaranteed* to fault? The above looks 
> like any future setup that supports 41 bits of addressing and has 
> extended the page tables (yes, it will happen eventually) will find 
> that to be a perfectly valid address?
> 
> It's also visually confusing, since it's visually very close to a real 
> kernel pointer too.
> 
> Grr.
> 
> Why not use something sane like 0xdead000000000000, which has the high 
> bit set but very fundamentally isn't a valid pointer, and never will 
> be? And which is a *lot* more visually obvious too!

initially i suggested that too - but such addresses raise a #GP instead 
of a page fault so their decoding is a bit harder.

We dont do any instruction decoding in #GP handlers to figure out what 
happened, while in the pagefault case we know which address faulted, 
etc.

Perhaps we could try to make #GP handlers a bit more informative - 
although decoding instructions will make things a bit more fragile 
inevitably.

Perhaps make it 0xffffcdead0000000 ?

in any case, please ignore this topic until it's all worked out - no 
other topics depend on this one so it can be skipped safely.

	Ingo
