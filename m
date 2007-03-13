Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXCMMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXCMMMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965711AbXCMMMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:12:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50390 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965702AbXCMMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:12:41 -0400
Date: Tue, 13 Mar 2007 13:15:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070313131533.1ec468c3@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
References: <7WzUo-1zl-21@gated-at.bofh.it>
	<7WAx2-2pg-21@gated-at.bofh.it>
	<7WAGF-2Bx-9@gated-at.bofh.it>
	<7WB07-3g5-33@gated-at.bofh.it>
	<7WBt7-3SZ-23@gated-at.bofh.it>
	<E1HQfLX-0000fk-68@be1.lrz>
	<f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	<Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	<f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	<20070313022430.57503b08@lxorguk.ukuu.org.uk>
	<f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But on that note -- do you have any idea how one might get ltrace to
> work on a multi-threaded program, or how one might enhance it to
> instrument function calls from one shared library to another?  Or

I don't know a vast amount about ARM ELF user space so no.

> better yet, can you advise me on how to induce gdbserver to stream
> traces of library/syscall entry/exits for all the threads in a
> process?  And then how to cram it down into the kernel so I don't take

One way to do this is to use kprobes which will do exactly what you want
as it builds a kernel module. Doesn't currently run on ARM afaik.

> the hit for an MMU context switch every time I hit a syscall or

Not easily with gdbstubs as you've got to talk to something to decide how
to log the data and proceed. If you stick it kernel side its a lot of
ugly new code and easier to port kprobes over, if you do it remotely as
gdbstubs intends it adds latencies and screws all your timings.

gdbstubs is also not terribly SMP aware and for low level work its
sometimes easier to have on gdb per processor if you can get your brain
around it.

Alan
