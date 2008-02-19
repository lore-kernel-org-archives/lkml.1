Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbYBSUJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbYBSUJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYBSUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:08:59 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34112 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751783AbYBSUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:08:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGfGukdMQWRV/2dsb2JhbACBWa4C
Date: Tue, 19 Feb 2008 15:08:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219200852.GC11197@Krystal>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:07:03 up 8 days, 16:07,  4 users,  load average: 0.69, 0.87,
	0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> Hi Mathieu,
> 
> On Feb 19, 2008 4:02 PM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > - stat(c, ALLOC_FASTPATH); seems to be using a var++, therefore
> >   indicating it is not reentrant if IRQs are disabled. Since those are
> >   only stats, I guess it's ok, but still weird.
> 
> What is not re-entrant?
> 

incrementing the variable with a "++" when interrupts are not disabled.
It's not an atomic add and it's racy. The code within stat() does
exactly this.

> On Feb 19, 2008 4:02 PM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > Since this shows mostly with network card drivers, I think the most
> > plausible cause would be an IRQ nesting over kmem_cache_alloc_node and
> > calling it.
> 
> Yes, this can happen. Are you saying it is not safe to be in the
> lockless path when an IRQ triggers?

It should be safe, but I think Eric pointed the correct problem in his
reply.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
