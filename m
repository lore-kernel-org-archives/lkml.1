Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZBIRkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZBIRkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZBIRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:39:55 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46365 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZBIRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:39:54 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Feb 2009 09:39:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
In-Reply-To: <cfd18e0f0902082345o7e36f4deo27fc3466aba66dad@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902090932320.8084@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com> <cfd18e0f0902082345o7e36f4deo27fc3466aba66dad@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Michael Kerrisk wrote:

> On Thu, Feb 5, 2009 at 11:58 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > People started using eventfd in scnarios where before where using pipes.
> > Many of them use eventfds in a semaphore-like way, like they were before
> > with pipes. The problem with eventfd is that a read() on the fd returns
> > and wipes the whole counter, making the use of it as semaphore a little
> > bit more cumbersome. You can do a read() followed by a write() of
> > COUNTER-1, but IMO it's pretty easy and cheap to make this work w/out
> > extra steps. This patch introduces a new eventfd flag that tells eventfd
> > to only dequeue 1 from the counter, allowing simple read/write to make it
> > behave like a semaphore.
> > Simple test here:
> >
> > http://www.xmailserver.org/eventfd-sem.c
> >
> >
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> Applied this patch against 2.6.29-rc3, and it works as I would expect.
> 
> 
> A question or two.... This change is rather specific to a single use
> case, so I wonder
> 
> a) Are there use cases that require the ability to read an arbitrary
> number of units off the eventfd -- i.e., read N units off the eventfd,
> rather than just 1?

Not that I can think of.


> b) Is it desirable to be able to toggle the EFD_SEMAPHORE behavior on
> and off for an eventfd?

This I'd say no. A synchronization entity in all decently sane sw design 
I've ever seen, remains the same in behaviour and it is never changed 
runtime to behave in different ways.


> It's difficult to see how these use cases could be accommodated in the
> current API, but I just thought it worth raising the ideas.

Since read/write semantics cannot be changed (besides, like the semaphore 
change, for the amount of "data" dequeued), deeper changes to the 
interface will have to go via ioctl(). But I don't see any reason to go 
that way ATM.



- Davide


