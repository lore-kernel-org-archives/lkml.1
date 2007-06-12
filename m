Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbXFLAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbXFLAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXFLAsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:48:13 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49372 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFLAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:48:12 -0400
Date: Mon, 11 Jun 2007 20:48:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ works
Message-ID: <20070612004804.GA9871@c2.user-mode-linux.org>
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org> <466DA50C.5050301@aladin.ro> <20070611211604.GA8859@c2.user-mode-linux.org> <466DCF1D.9050508@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DCF1D.9050508@aladin.ro>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 01:39:25AM +0300, Eduard-Gabriel Munteanu wrote:
> The cast isn't done right. Doing "fd = (long) dev_id;" doesn't help, 
> since you pass fd to mconsole_get_request() as is. And 
> mconsole_get_request() expects an integer:
> int mconsole_get_request(int fd, struct mc_request *req)

gcc will trim a long to an integer correctly.  You can pass a long to
an integer without casting.

> This will generate at least a warning on arches where sizeof(int) != 
> sizeof(long). 

No it won't.  UML builds without warnings here on x86_64.

> And by the way, AFAIK, GCC has the habit of breaking compatibility with 
> some userspace apps when a new GCC major version is released. And, 
> AFAIK, they're moving towards standards, so relying on GCC's 
> "guarantees" may backfire.

The GCC guarantee I'm talking about it LP64 - I'm highly confident
that's not changing any time soon.

> >>You're calling glibc functions
> >>with that fd as a parameter. On some arches, compiling will issue
> >>warnings or simply fail. 
> >
> >Which ones?
> >
> 
> An example is sparc64:
> quote from
> >>http://lxr.linux.no/source/include/asm-sparc64/types.h#L49

What warnings does this produce?  These are the same sizes as x86_64
(and every other 64-bit arch that Linux runs on, I bet), where this
code compiles without warning.

> Really, a kmalloc() isn't such a big deal, it only happens once and 
> we're not in interrupt context.

It's not the runtime cost - it's the extra code.

> One the other hand, ensuring safety and 
> portability on other arches is something that needs to be taken care
> of.

You haven't demonstrated any safety or portability problems yet.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
