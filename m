Return-Path: <linux-kernel-owner+w=401wt.eu-S1423258AbXBIWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423258AbXBIWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423270AbXBIWDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:03:36 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3074 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423258AbXBIWDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:03:35 -0500
Date: Fri, 9 Feb 2007 22:03:27 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070209220327.GB16158@flint.arm.linux.org.uk>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	linux-kernel@vger.kernel.org, drepper@redhat.com
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <20070209214944.GA16158@flint.arm.linux.org.uk> <1171057999.29713.129.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171057999.29713.129.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 09:53:19PM +0000, David Woodhouse wrote:
> On Fri, 2007-02-09 at 21:49 +0000, Russell King wrote:
> > urgh, new system calls... wonder if they fit in the ARM ABI...  Looks
> > fine.
> 
> Can you elucidate on _what_ you just checked for?
> 
> There was something about alignment of 64-bit arguments to syscalls
> which affects MIPS and/or ARM which I can't quite remember--

It's something like that.

> something
> about putting it them arguments in either an even-numbered or
> odd-numbered position to make it work nicely.

We have a maximum of 7 32-bit registers to pass system call arguments.
In EABI, 64-bit arguments must be aligned to an even-numbered register
(starting at zero).  In OABI, 64-bit arguments do not have this
restriction.

So, for EABI:

sys_foo(int a, unsigned long long b, int c, unsigned long long d)

would allocate 'a' into r0, 'b' into r2,r3, 'c' into r4, and 'd' into
r6, and oops we're out of registers - so the above syscall prototype
can't be supported on ARM.

However:

sys_foo(int a, int c, unsigned long long b, unsigned long long d)

is entirely reasonable and leaves us with spare room for one additional
32-bit arg to be passed.

> Is that actually written anywhere, and does anyone bother to check?

Mostly mailing list archives I'd guess.  As far as anyone bothering
to check, that's me when I'm aware of new syscalls... which typically
happens a long time after the syscalls have been introduced on x86
etc.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
