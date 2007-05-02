Return-Path: <linux-kernel-owner+w=401wt.eu-S1767116AbXEBSVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767116AbXEBSVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767117AbXEBSVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:21:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2475 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767116AbXEBSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:21:45 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 2 May 2007 11:21:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>  <20070502053427.123392000@haxent.com.br>
  <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com> 
 <20070502095503.a06f5472.dada1@cosmosbay.com> 
 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com> 
 <20070502104936.674a4b54.dada1@cosmosbay.com> 
 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com> 
 <4638C37D.7050503@haxent.com.br>  <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
  <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Ulrich Drepper wrote:

> On 5/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Is it? Please do tell me more...
> 
> Come on, we went through all this.  Having to do syscalls for event
> retrieval plus the limited channel available for feedback (the POLL*
> bits) is to limiting.  This is where the kevent stuff innovated and
> really fixed the problems.  Userlevel ring buffers are more efficient.
> 
> Yes, a unifying event look is what is wanted.  But it does not have to
> be poll based.  Given the right abstraction you can fit in the kevent
> technology or similar things.
> 
> And seeing all these requirements of this approach: kevent is also
> much more resource efficient.  No "one file desriptor per thread per
> object".  These are important factors.

99% of the fds you'll find inside an event loop you care to scale about, 
are *already* fd based.   The handful of the remaining ones (signals, 
timers, AIO signaling, ??) will likely account for a *very limited* number 
of fds.   On top of that, those fds are very cheap in terms of memory 
(they're basically wakeup targets), since the new code shares the inode 
for them.   So we have a limited number of fds, using a pretty limited 
amount of memory each.
And this approach is not bound to a completely new and monolitic interface.
All these things need to basically deliver notifications of completion, 
and being able to read results.   Things that the existing f_op->poll and 
f_op->read are already able to give us.   Is that really a strange concept 
to base it on?   Because, to me, it seems pretty natural.



- Davide


