Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXFCTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXFCTQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 15:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXFCTQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 15:16:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3584 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXFCTQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 15:16:22 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 12:16:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Aaron Wiebe <epiphani@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706031159200.13247@alien.or.mcafeemobile.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Aaron Wiebe wrote:

> (ps.  having come from the socket side of the fence, its incredibly
> frustrating to be unable to poll() or epoll regular file FDs --
> Especially knowing that the kernel is translating them into a TCP
> socket to do NFS anyway.  Please add regular files to epoll and give
> me a way to do the opens in the same fasion as connects!)

You may want to follow Ingo and Zach work on syslets/threadlets. If that 
goes in, you can make *any* syscall asynchronous.
I ended up writing a userspace library, to cover the same exact problem 
you have:

http://www.xmailserver.org/guasi.html

I basically host an epoll_wait (containing all my sockets, pipes, etc) 
inside a GUASI async request, where other non-pollable async requests are 
hosted. So guasi_fetch() becomes my main event collector, and when the 
epoll_wait async request show up, I handle all the events in there.
This is a *very-trivial* HTTP server using such solution (coroutines, 
epoll and GUASI):

http://www.xmailserver.org/cghttpd-home.html



- Davide


