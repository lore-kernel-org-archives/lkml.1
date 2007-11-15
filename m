Return-Path: <linux-kernel-owner+w=401wt.eu-S1764588AbXKOBL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764588AbXKOBL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKOBLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:11:18 -0500
Received: from ozlabs.org ([203.10.76.45]:38982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbXKOBLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:11:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.40110.831730.847548@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 12:11:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.152134.266510129.davem@davemloft.net>
References: <18235.28062.309910.416774@cargo.ozlabs.ibm.com>
	<20071114.150303.13732085.davem@davemloft.net>
	<18235.32982.439970.359975@cargo.ozlabs.ibm.com>
	<20071114.152134.266510129.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> From: Paul Mackerras <paulus@samba.org>
> Date: Thu, 15 Nov 2007 10:12:22 +1100
> 
> > *I* never had a problem with a few extra system calls.  I don't
> >  understand why you (apparently) do.
> 
> We're stuck with them forever, they are hard to version and extend
> cleanly.
> 
> Those are my main objections.

The first is valid (for suitable values of "forever") but applies to
any user/kernel interface, not just system calls.

As for the second (hard to version) I don't see why it applies to
syscalls specifically more than to other interfaces.  It's just a
matter of designing it correctly in the first place.  For example, the
sys_swapcontext system call we have on powerpc takes an argument which
is the size of the ucontext_t that userland is using, which allows us
to extend it in future if necessary.  (Note that I'm not saying that
the current perfmon2 interfaces are well-designed in this respect.)

The third (hard to extend cleanly) is a good point, and is a valid
criticism of the current set of perfmon2 system calls, I think.
However, the goal of being able to extend the interface tends to be in
opposition to the goal of having strong typing of the interface.
Things like a multiplexed syscall or an ioctl are much easier to
extend but that is at the expense of losing strong typing.  Something
like my transaction() (or your weird kind of read() :) also provides
extensibility but loses type safety to some degree.

Also, as Andi says, this is core CPU state that we are dealing with,
not some I/O device, so treating the whole of perfmon2 (or any
performance monitoring infrastructure) as a driver doesn't fit very
well, and in fact system calls are appropriate.  Just like we don't
try to make access to debugging facilities fit into a driver, we
shouldn't make performance monitoring fit into a driver either.

Paul.
