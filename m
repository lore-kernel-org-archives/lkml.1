Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZBCUfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZBCUfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZBCUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:34:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49946 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZBCUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:34:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Feb 2009 12:34:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
In-Reply-To: <alpine.LFD.2.00.0902031219520.3247@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0902031231110.23050@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2> <20090203001401.cc960d4e.akpm@linux-foundation.org> <alpine.DEB.1.10.0902031011380.23050@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0902031116500.23050@alien.or.mcafeemobile.com>
 <20090203121041.23d440be.akpm@linux-foundation.org> <alpine.LFD.2.00.0902031219520.3247@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Linus Torvalds wrote:

> 
> 
> On Tue, 3 Feb 2009, Andrew Morton wrote:
> > > 
> > > Actually reading the comments helps :) It triggers an include-hell, if you 
> > > make them inline. Since they're lockdep debug thingies, I think it's kinda 
> > > wasted turn them into non-inline real functions, so they'd better remain 
> > > macros IMO.
> > 
> > ho hum.  I think it'd be worth at least renaming the arguments to
> > something less daft, for readability reasons.
> 
> Also, maybe we can make it an out-of-line thing rather than an inline?
> 
> Why not just make it
> 
> 	extern void wake_up_nested[_poll](wait_queue_head_t *,
> 		[unsigned long pollflags, ] unsigned int nesting);
> 
> and then just move it out of a header file entirely by writing it as a 
> real function in some *.c file that only gets compiled with 
> DEBUG_LOCK_ALLOC.
> 
> Hmm? No include hell.

There's another thing. Epoll is the *only* user of such thing. I could 
suck it in there if you prefer. wake_up_nested(), once 
wake_up_nested_poll() goes in, has no more users and IMO can go.
Otherwise yes, we could define:

void wake_up_nested_poll(wait_queue_head_t *q, unsigned long events,
                         int subclass);

in wait.h, and define it under DEBUG_LOCK_ALLOC in sched.c.
Let me know what you'd like best ...



- Davide


