Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZDBOAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZDBOAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbZDBN76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:59:58 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:59282 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZDBN75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:59:57 -0400
Date: Thu, 2 Apr 2009 09:53:31 -0400 (EDT)
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
In-Reply-To: <20090402034223.GA25791@elte.hu>
Message-ID: <alpine.DEB.1.10.0904020948570.31756@qirst.com>
References: <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com>
 <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com> <20090402034223.GA25791@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Ingo Molnar wrote:

> to quote an earlier part of my mail:
>
> > > We encourage kfree(NULL) and it triggers commonly in the kernel
> > > today [on distro kernels we checked it can trigger once per
> > > syscall!] - so i think we should consider free_percpu(NULL) a
> > > possibly common pattern too. (even though today it's likely
> > > _not_ common at all.)
>
> I specifically mentioned that it is not at all common now.

What is this? Nonsense day? Consider it a common pattern although its
likely not common at all? April fools day?

> But there's no reason why an object shutdown fastpath with an
> optional percpu buffer (say for debug statistics, not enabled by
> default) couldnt look like this:
>
> 	percpu_free(NULL);
>
> We actually have such patterns of kfree(ptr) use, where the _common_
> case in a fastpath is kfree(NULL).

Speculation. A shutdown fastpath? The percpu allocation and free
operations are expensive and deal with teardown and setup of virtual
mappings. Those paths are *not* optimized for fastpath use. kfree is
different.


