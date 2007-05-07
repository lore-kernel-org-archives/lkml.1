Return-Path: <linux-kernel-owner+w=401wt.eu-S967054AbXEGWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967054AbXEGWfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966719AbXEGWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:35:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1321 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966550AbXEGWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:35:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 7 May 2007 15:35:38 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com>
References: <20070504225730.490334000@haxent.com.br>  <463BC3CA.6050109@haxent.com.br>
  <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com> 
 <463CFA37.3020809@haxent.com.br>  <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
  <463F9B68.305@haxent.com.br> <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Ulrich Drepper wrote:

> On 5/7/07, Davi Arnaut <davi@haxent.com.br> wrote:
> > See Linus's message on this same thread.
> 
> No.  I'm talking about the userlevel side, not kernel side.
> 
> If a thread is canceled *after* it returns from the syscall but before
> it reports the event to the call (i.e., while still in the syscall
> wrapper, thread cancellation rules require a check there) the event is
> lost.

read(2) is a cancellation point too. So if the fine userspace code issues 
a random pthread_cancel() to a thread handling that, data is lost together 
with the session that thread was handling. Hmm, I wonder how the world 
could have functioned so far.
Bottom line is, if you really want to throw random cancels to your worker 
threads, you better wrap them into pthread_cleanup_push(). Because 
otherwise, no matter where your cancel hits, you end up with a broken 
system.



- Davide


