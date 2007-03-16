Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbXCPQXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbXCPQXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXCPQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:23:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36141 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753563AbXCPQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:23:30 -0400
Date: Fri, 16 Mar 2007 17:25:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070316172539.1e3e49d5@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703141309l20f907c4t6d0bb7dcef724947@mail.gmail.com>
References: <7WzUo-1zl-21@gated-at.bofh.it>
	<7WB07-3g5-33@gated-at.bofh.it>
	<7WBt7-3SZ-23@gated-at.bofh.it>
	<E1HQfLX-0000fk-68@be1.lrz>
	<f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	<Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	<f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	<20070313022430.57503b08@lxorguk.ukuu.org.uk>
	<f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	<20070313131533.1ec468c3@lxorguk.ukuu.org.uk>
	<f2b55d220703141309l20f907c4t6d0bb7dcef724947@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > gdbstubs is also not terribly SMP aware and for low level work its
> > sometimes easier to have on gdb per processor if you can get your brain
> > around it.
> 
> That's a trick I don't know.  What do you do, fire up the target
> process, put the whole thing to sleep with a SIGSTOP, and then attach
> a separate gdb to each thread after they've been migrated and locked
> down to the destination CPU?

gdbstubs/kgdbstubs is kernel side so you boot the two cores and each core
halts in the debugger on a breakpoint trap. One debug stub uses one
serial port (or one UDP port), the other uses a different one.

Two gdbs and you can stop/play with each processor independently.
