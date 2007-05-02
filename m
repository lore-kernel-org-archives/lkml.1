Return-Path: <linux-kernel-owner+w=401wt.eu-S2992913AbXEBItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992913AbXEBItk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992923AbXEBItk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:49:40 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:44221 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992916AbXEBItj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:49:39 -0400
Date: Wed, 2 May 2007 10:49:36 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Davi Arnaut" <davi@haxent.com.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Message-Id: <20070502104936.674a4b54.dada1@cosmosbay.com>
In-Reply-To: <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
References: <20070502052235.914764000@haxent.com.br>
	<20070502053427.123392000@haxent.com.br>
	<a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	<20070502095503.a06f5472.dada1@cosmosbay.com>
	<a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 01:08:26 -0700
"Ulrich Drepper" <drepper@gmail.com> wrote:

> On 5/2/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Well, poll() level edge semantic is well defined, you cannot cheat or change it.
> >
> > If many threads call poll() on the same end point, they should *all* return POLLIN/whatever status.
> 
> This means to me it's the wrong abstraction for this.  We had a nice
> solution for this with Evgeniy's kevent interfaces.  It worked without
> forcing futexes is this inflexible poll() interface.

poll() is a generalist interface. Not the *perfect* one, but well spreaded on other OS as well.

> 
> 
> 
> > This is why programs usually use one thread to dispatch events to workers, or at least dont queue XXXX threads calling poll() on one fd.
> 
> No.  This is why programs are forced to waste cycles by doing this.
> Ideally this would not happen.  Ideally you'd park all worker thread
> in the same place and have them woken up one by one.  Again, Evgeniy's
> code was able to do this.  This approach seems to be a big step
> backward.

I understand your concerns, but *this* patch bundle extends poll()/select()/epoll, and is not an alternative to kevent or other work in progress, (and linux centered)

Are you suggesting poll() system call should be deprecated ?

Most programs still use the archaic select() thing you know ...

