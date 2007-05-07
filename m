Return-Path: <linux-kernel-owner+w=401wt.eu-S967092AbXEGWr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967092AbXEGWr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXEGWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:47:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1500 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEGWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:47:25 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 7 May 2007 15:47:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705071543160.29173@alien.or.mcafeemobile.com>
References: <20070504225730.490334000@haxent.com.br>  <463BC3CA.6050109@haxent.com.br>
  <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com> 
 <463CFA37.3020809@haxent.com.br> <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Ulrich Drepper wrote:

> On 5/5/07, Davi Arnaut <davi@haxent.com.br> wrote:
> > A google search turns up a few users. It also addresses some complaints
> > from Drepper.
> 
> There is a huge problem with this approach and we're back at the
> inadequate interface.
> 
> select/poll/epoll are thread cancellation points.  I.e., the thread
> can be canceled before returning to the user.  If this cancellation
> happens between the kernel deciding to give this thread the event (and
> no other thread) and the thread testing for cancellation in the libc
> wrapper around the syscall, then the event is lost and the process(es)
> might hang.
> 
> With kevent we in the end fixed the problem by requiring that part of
> the cancellation handling the thread tries to wake up another thread
> waiting for the event queue.  This is easily possible since the event
> data is in the shared memory segment and it's just purely the thread
> wakeup that is needed.

So, by the same logic, every API that 1) returns something to userspace 
by canceling its internal kernel state 2) is not based on shared 
kernel/userspace memory, will break under your assumptions.
Scary, because there's a pretty long list.



- Davide


