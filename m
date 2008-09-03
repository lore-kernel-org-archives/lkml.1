Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYICF50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYICF50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 01:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYICF5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 01:57:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbYICF5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 01:57:16 -0400
Date: Tue, 2 Sep 2008 22:57:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (more) epoll troubles
Message-Id: <20080902225703.efe29299.akpm@linux-foundation.org>
In-Reply-To: <48BA9EB9.3040701@cosy.sbg.ac.at>
References: <48BA9EB9.3040701@cosy.sbg.ac.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 15:38:01 +0200 Michael Noisternig <mnoist@cosy.sbg.ac.at> wrote:

> Hello,
> 
> and sorry again if this is the wrong place to ask (again, please hint to 
> me to an appropriate place to ask in that case).
> 
> After experimenting with epoll edge-triggered mode I am clueless why on 
> a few occassions I seem to not get any input notification despite data 
> is available.
> 
> In detail: I have set up sockets with epoll events 
> EPOLLET|EPOLLRDHUP|EPOLLIN. When I get EPOLLIN for a socket, I read() as 
> long as I get what I asked for, i.e. whenever read() returns either 
> EAGAIN or less data than I asked for I take this as indication that I 
> must wait for another EPOLLIN notification. However, this does not seem 
> to work always.
> 
> Here is some log from my program:
> 
> 0x9e6b8a8: read not avail (1460/2048 read)
> i.e. tried to read 2048 bytes, got 1460 -> assume must wait for EPOLLIN 
> for more data to read
> (note that the fd is always in the epoll set with 
> EPOLLET|EPOLLRDHUP|EPOLLIN)
> 
> 0x9e6b8a8: read not avail (1460/2048 read)
> got EPOLLIN notification, read 1460 bytes again -> wait for another 
> notification
> 
> ...after a few minutes without any notification...
> 
> 0x9e6b8a8: GOT RDHUP (2001:0/80002001:0)
> i.e. got notification for EPOLLRDHUP|EPOLLIN (2001), was waiting for 
> EPOLLET|EPOLLRDHUP|EPOLLIN (80002001)
> 
> 0x9e6b8a8: read not avail (342/2048 read)
> then on trying to read we find data in the buffer (???)
> 
> 0x9e6b8a8: stored 16384 bytes
> this is the amount of data we expected to get /immediately/, i.e. 
> without a minutes delay and rdhup
> 
> Of course you might think that the other side sent the data only just 
> before closing its side, but it is unlikely since we expected to get the 
> 16384 bytes in one go (this is how that L7 protocol works), and I see 
> this odd behaviour of missing input notifications now and then.
> 
> Does anybody know/have an idea why I am missing EPOLLIN notifications?
> 

If you can put together a little test case which others can run then we
should be able to get this resolved super-quick.

Thanks.
