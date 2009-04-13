Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZDMS2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZDMS2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZDMS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:27:50 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:58577 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZDMS1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:27:50 -0400
Date: Mon, 13 Apr 2009 14:18:08 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090408162651.GA14449@elte.hu>
Message-ID: <alpine.DEB.1.10.0904131409510.13756@qirst.com>
References: <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain>
 <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com> <20090402034223.GA25791@elte.hu> <alpine.DEB.1.10.0904020948570.31756@qirst.com> <20090408162651.GA14449@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Ingo Molnar wrote:

> Dude, this is a new facility freshly modernized and freshly made
> usable. What did you expect, for a thousand usecases pop up in the
> kernel overnight? _None_ of this code is "common" today per se. (the
> networking folks are working on making it more and more common
> though)

?? kfree(NULL) has been allowed for years. None of this is new.

> > Speculation. A shutdown fastpath? The percpu allocation and free
> > operations are expensive and deal with teardown and setup of
> > virtual mappings. Those paths are *not* optimized for fastpath
> > use. kfree is different.
>
> Of course a lot of this is speculation, dynamic percpu so far has
> been a rarely used facility compared to kmalloc()/kfree(). If you
> dont accept my analogy that's fine - but that is opinion against
> opinion - while you state you opinion as truism.


Please look at the kernel source for the use of percpu_free and
percpu_alloc.

> So my point remains: your patch had effects you clearly did not
> anticipate, and the cacheline alignment management situation is not
> nearly as clear-cut as you imagine it to be.

There was no effect that I did not anticipate. Just imagination on your
part that percpu_free is used like kfree.

Again: The frequent insertion of __read_mostly will
destroy the purpose and function of the read mostly areas!

> Unfortunately you failed to answer my detailed mail that made very
> specific points though, you only got into generalities and flames
> about my summary mail - so it's hard to judge what your opinion
> about those specific facts is - you have not stated one.

I was pretty clear on those points. Not sure what material question I did
not answer. What you say here fits your posts. Generalizing from kfree to
percpu_free etc...
