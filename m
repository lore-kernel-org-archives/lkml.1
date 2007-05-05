Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXEEVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXEEVmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933907AbXEEVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:42:21 -0400
Received: from haxent.com ([65.99.219.155]:3964 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbXEEVmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:42:20 -0400
Message-ID: <463CFA37.3020809@haxent.com.br>
Date: Sat, 05 May 2007 18:42:15 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br> <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Fri, 4 May 2007, Davi Arnaut wrote:
> 
>> Hi,
>>
>> If multiple threads are parked on epoll_wait (on a single epoll fd) and
>> events become available, epoll performs a wake up of all threads of the
>> poll wait list, causing a thundering herd of processes trying to grab
>> the eventpoll lock.
>>
>> This patch addresses this by using exclusive waiters (wake one). Once
>> the exclusive thread finishes transferring it's events, a new thread
>> is woken if there are more events available.
>>
>> Makes sense?
> 
> Theorically, make sense. I said theorically because all the use 
> epoll_wait MT use cases I've heard of, use a single thread that does the 
> epoll_wait, and then dispatch to worker threads. So thundering herd is not 
> in the picture. OTOH, it does not hurt either.

A google search turns up a few users. It also addresses some complaints
from Drepper.

> But, that code is completely changed with the new single-pass epoll delivery 
> code that is in -mm. So, I'd either wait for that code to go in, or I 
> (or you, if you like) can make a patch against -mm.

Fell free to update the patch for -mm and to include my signed-of-by.
Thanks.

--
Davi Arnaut

