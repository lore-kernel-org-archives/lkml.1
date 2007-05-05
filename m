Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbXEETAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbXEETAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXEETAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:00:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3962 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbXEETAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:00:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 5 May 2007 12:00:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Davi Arnaut <davi@haxent.com.br>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <463BC3CA.6050109@haxent.com.br>
Message-ID: <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Davi Arnaut wrote:

> Hi,
> 
> If multiple threads are parked on epoll_wait (on a single epoll fd) and
> events become available, epoll performs a wake up of all threads of the
> poll wait list, causing a thundering herd of processes trying to grab
> the eventpoll lock.
> 
> This patch addresses this by using exclusive waiters (wake one). Once
> the exclusive thread finishes transferring it's events, a new thread
> is woken if there are more events available.
> 
> Makes sense?

Theorically, make sense. I said theorically because all the use 
epoll_wait MT use cases I've heard of, use a single thread that does the 
epoll_wait, and then dispatch to worker threads. So thundering herd is not 
in the picture. OTOH, it does not hurt either.
But, that code is completely changed with the new single-pass epoll delivery 
code that is in -mm. So, I'd either wait for that code to go in, or I 
(or you, if you like) can make a patch against -mm.



- Davide


