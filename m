Return-Path: <linux-kernel-owner+w=401wt.eu-S1161893AbXEDTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161893AbXEDTPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161894AbXEDTPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:15:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4797 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161893AbXEDTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:15:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 4 May 2007 12:15:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>  <4638C37D.7050503@haxent.com.br>
  <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com> 
 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com> 
 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com> 
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com> 
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com> 
 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com> 
 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com> 
 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Ulrich Drepper wrote:

> On 5/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Why is that futexes *must* be part of the "whole solution"? Ppl needs
> > solutions to specific problems, not an bloated interface that, like a
> > giant blob, includes everything just because it exists.
> 
> Sync objects are essential parts of many programs today and most
> programs tomorrow.  Currently you cannot efficiently implement working
> on multiple independent areas which are protected through some sync
> object (mutex, condvar, ...).  You have to create a separate thread
> for each.  Looping with the nonlocking mutex, for instance, is no
> possibility.  This is solved by being able to get events for the
> availability of the sync object.
> 
> And before you start and claim that this is no common cases take a
> look at the waitformultipleobjects (with studdly caps somewhere) for
> windows' API.  The actual interface is horrible, but the concept is
> sound (it comes from VMS).  This is the basis of many programs on that
> platform.  Basically, the central loop contains such a call.
> Currently programs would have to be completely redesigned when ported
> to Linux if they use any object which cannot be waited on.
> 
> There is much more.  As I tried to point out in last year's OLS paper,
> central loops around such a call are the perfect scalability mechanism
> and this is what is needed for the processors from today and tomorrow.

This is a pretty specific case, that is not very typical to find in the 
usual common event loop dispatch application design.
But strange you went even there, because, as you know, WaitForMultipleObjects
works with HANDLEs, that are the closest thing to the Unix file you can 
find. They can be read (ReadFile/read), written (WriteFile/write), closed 
(CloseHandle/close), duplicated (DuplicateHandle/dup) and waited 
(WaitForMultipleObjects/poll), with a common interface.
And if you *really* want your truly generic WaitForMultipleObjects 
implementation, your only way is to base it on files. Files are our almost 
perfect match to HANDLEs in our world. We have the basic infrastructure 
already there.




- Davide


