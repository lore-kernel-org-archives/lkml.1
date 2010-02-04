Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab0BDTqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:46:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:48158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932572Ab0BDTq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:46:29 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18nF8lDHQgnP0J5OS3Pakk88FFA91LlX38Od8XU/W
	CzSYRUBS+9BQYl
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
References: <1265245849.3362.1.camel@localhost>
	<1265256174.2952.11.camel@localhost>
	<alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
	<1265272174.2952.20.camel@localhost>
	<20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
	<alpine.LFD.2.00.1002041102530.3707@localhost.localdomain>
Date: Thu, 04 Feb 2010 20:45:42 +0100
In-Reply-To: <alpine.LFD.2.00.1002041102530.3707@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 4 Feb 2010 11:11:44 -0800 (PST)")
Message-ID: <87r5p0wzrt.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-04 20:11 +0100, Linus Torvalds wrote:

> Sven/Ben: is /sbin/init (or wherever debian puts it) a regular ELF file? 
> Shared libraries? Anything at all special about it? I wonder why it seems 
> to have issues, when other 32-bit programs don't.

,----
| % file /sbin/init
| /sbin/init: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
| % ldd /sbin/init
| 	linux-gate.so.1 =>  (0xf770d000)
| 	libsepol.so.1 => /lib/libsepol.so.1 (0xf76c0000)
| 	libselinux.so.1 => /lib/libselinux.so.1 (0xf76a6000)
| 	libc.so.6 => /lib/i686/cmov/libc.so.6 (0xf755e000)
| 	libdl.so.2 => /lib/i686/cmov/libdl.so.2 (0xf755a000)
| 	/lib/ld-linux.so.2 (0xf770e000)
`----

Apparently nothing special, and booting with init=/bin/bash does not
change anything.

Sven
