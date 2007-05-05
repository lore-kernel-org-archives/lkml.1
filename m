Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXEESzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXEESzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXEESzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:55:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1934 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXEESzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:55:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 5 May 2007 11:54:57 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br> 
 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com> 
 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com> 
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com> 
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com> 
 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com> 
 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com> 
 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com> 
 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com> 
 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Ulrich Drepper wrote:

> On 5/4/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > This is a pretty specific case, that is not very typical to find in the
> > usual common event loop dispatch application design.
> 
> This is where you are very wrong.  Yes, it's rare in the Unix world
> because non-trivial programs cannot implement this in most cases with
> the available infrastructure.  But it is very common in other places
> and what is more, it makes a lot of sense.  It gives you scalability
> with the size of the machines at no cost associated to reorganizing
> the program.

But we have our own *sane* version of WaitForMultipleObjects, and it's 
called poll(2).



> > And if you *really* want your truly generic WaitForMultipleObjects
> > implementation, your only way is to base it on files. Files are our almost
> > perfect match to HANDLEs in our world. We have the basic infrastructure
> > already there.
> 
> "basic", but not complete.  And I never said that the implementation
> thye have is perfect, far from it.  The concept is good and if we now
> can implement it, with all the event sources available, using an
> efficient event delivery mechanism we are far ahead of their design.
> 
> The proposal now  on the table doesn't bring us there all the way and
> it has the potential to make future work in the area of event delivery
> harder just because there is more legacy code to be kept  happy.  This
> is why I propose to not consider these changes and instead go for the
> gold, i.e., the full solution.

So, on one side we have a proposal made by a set of new modular objects 
that fits our own infrastructure (internal - kernel, and external - POSIX) 
and that are not bound to a specific interface.
On the other side we have a completely new, monolitic interface, whose 
objects are strictly bound to it and are not usable if not only inside the 
interface itself.
Now, considering that POSIX is the backbone of Linux (and *nix in 
general), and considering that we certainly cannot drop existing POSIX 
semantics, where the lagacy code will come from?
I really do not understand your point. You're too smart to not appreciate 
the beauty and the simmetry of objects that responds to a common interface 
(our files, win32 handles), and that fits our existing kernel infrastructure.




- Davide


