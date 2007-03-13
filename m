Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXCMBWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXCMBWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 21:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbXCMBWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 21:22:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752989AbXCMBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 21:22:13 -0400
Date: Tue, 13 Mar 2007 02:24:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070313022430.57503b08@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
References: <7WzUo-1zl-21@gated-at.bofh.it>
	<7WAx2-2pg-21@gated-at.bofh.it>
	<7WAGF-2Bx-9@gated-at.bofh.it>
	<7WB07-3g5-33@gated-at.bofh.it>
	<7WBt7-3SZ-23@gated-at.bofh.it>
	<E1HQfLX-0000fk-68@be1.lrz>
	<f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	<Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	<f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Writing to a file from multiple processes is not usually the problem.
> Writing to a common "struct file" from multiple threads is.

Not normally because POSIX sensibly invented pread/pwrite. Forgot
preadv/pwritev but they did the basics and end of problem

> So what?  My products are shipping _now_.  

That doesn't inspire confidence.

> even funny.  If POSIX mandates stupid shit, and application
> programmers don't read that part of the manual anyway (and don't code
> on that assumption in practice), to hell with POSIX.  On many file

Thats funny, you were talking about quality a moment ago.

> descriptors, short writes simply can't happen -- and code that

There is almost no descriptor this is true for. Any file I/O can and will
end up short on disk full or resource limit exceeded or quota exceeded or
NFS server exploded or ...

And on the device side about the only thing with the vaguest guarantees
is pipe().

> purports to handle short writes but has never been exercised is
> arguably worse than code that simply bombs on short write.  So if I
> can't shim in an induce-short-writes-randomly-on-purpose mechanism
> during development, I don't want short writes in production, period.

Easy enough to do and gcov plus dejagnu or similar tools will let you
coverage analyse the resulting test set and replay it.

> Sure -- until the one code path in a hundred that handles the "short
> write" case incorrectly gets traversed in production, after having
> gone untested in a development environment that used a different
> filesystem that never happened to trigger it.

Competent QA and testing people test all the returns in the manual as
well as all the returns they can find in the code. See ptrace(2) if you
don't want to do a lot of relinking and strace for some useful worked
examples of syscall hooking.

Alan
