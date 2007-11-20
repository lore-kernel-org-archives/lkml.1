Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbXKTSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbXKTSY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXKTSYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:24:52 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:37283 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbXKTSYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:24:51 -0500
Message-ID: <47432666.6070503@oracle.com>
Date: Tue, 20 Nov 2007 10:24:38 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com>
In-Reply-To: <474323CA.9030306@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> That's only because you're being, deliberately or accidentally, vague
> about what your actual (as opposed to imagined) requirements are.

Maybe I can help by summarizing how syslets fit in to this.

Currently the syslet patches add a single submission call which includes
an argument which is a structure which duplicates the system call ABI.
The submission syscall in the kernel does some syslet specific work
which amounts to verifying state and storing it in the task_struct.  It
then has to unpack the system call arguments from this submission
syscall argument and call the specified system call.

Every architecture will need helpers, then, on either side.  They'll
need to pack their arguments into the struct and then unpack and call in
the kernel.  The PPC64 guys have already expressed concern about this.

It's, in effect, adding the syslet arguments to every single system call.

So, instead of duplicating the system call ABI in the argument to a
syslet submission syscall, we could pass the syslet arguments via this
indirect parameters convention.  This, hopefully, will reduce complexity
by reducing the number of places that we have to muck around with the
sycall ABI.

That's the high level summary, anyway.  I'm working on the simplest
expression of this mechanism at the moment.  We'll have code to argue
about before the silly thanksgiving break, I hope.

- z
