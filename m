Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab0BDTzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:55:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932681Ab0BDTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:55:52 -0500
Date: Thu, 4 Feb 2010 11:54:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sven Joachim <svenjoac@gmx.de>
cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
In-Reply-To: <87r5p0wzrt.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.00.1002041150100.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
 <alpine.LFD.2.00.1002041102530.3707@localhost.localdomain> <87r5p0wzrt.fsf@turtle.gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Sven Joachim wrote:

> On 2010-02-04 20:11 +0100, Linus Torvalds wrote:
> 
> > Sven/Ben: is /sbin/init (or wherever debian puts it) a regular ELF file? 
> > Shared libraries? Anything at all special about it? I wonder why it seems 
> > to have issues, when other 32-bit programs don't.
> 
> ,----
> | % file /sbin/init
> | /sbin/init: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> | % ldd /sbin/init
> | 	linux-gate.so.1 =>  (0xf770d000)
> | 	libsepol.so.1 => /lib/libsepol.so.1 (0xf76c0000)
> | 	libselinux.so.1 => /lib/libselinux.so.1 (0xf76a6000)
> | 	libc.so.6 => /lib/i686/cmov/libc.so.6 (0xf755e000)
> | 	libdl.so.2 => /lib/i686/cmov/libdl.so.2 (0xf755a000)
> | 	/lib/ld-linux.so.2 (0xf770e000)
> `----
> 
> Apparently nothing special, and booting with init=/bin/bash does not
> change anything.

Yeah, well, if my current -git tree works, then there is something else 
going on. 

But I don't really see anything relevant _except_ for those commits. I do 
note that mainline also has the do_wait() thread optimizations since 
2.6.32, and I guess those aren't in stable, but I really don't see them 
interacting with that whole flush_old_exec thing in any way.

Very odd.

		Linus
