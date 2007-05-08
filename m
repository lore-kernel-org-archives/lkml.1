Return-Path: <linux-kernel-owner+w=401wt.eu-S967771AbXEHEgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967771AbXEHEgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966795AbXEHEgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:36:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967685AbXEHEgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:36:02 -0400
Date: Mon, 7 May 2007 21:35:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0705072132580.3974@woody.linux-foundation.org>
References: <20070504225730.490334000@haxent.com.br>  <463BC3CA.6050109@haxent.com.br>
  <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com> 
 <463CFA37.3020809@haxent.com.br>  <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
  <463F9B68.305@haxent.com.br>  <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
  <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com>
 <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Ulrich Drepper wrote:
> 
> This is absolutely not comparable.  When read/write is canceled no
> data is lost.  Some other thread might have to pick up the slack but
> that's it.

That's bullsh*t, Uli, and you know it.

Whatever the thread read() into it's buffer is effectively gone. You don't 
know how much of the buffer was updated, so other threads cannot use the 
data.

In fact, the exact *reverse* of what you claim is true. With "poll()" or 
"select()", other threads *can* actually look at the result buffer, since 
it has a known size and format that is independent of the return value, 
unlike read().

But the real issue is that if you start cancellign threads without any 
other synchronization, you are going to lose data anyway. Claiming 
anything else is just silly. The whole scenario you talk about is 
nonsensical, never mind that read() actually handles it *less* well rather 
than better as you claim.

		Linus
