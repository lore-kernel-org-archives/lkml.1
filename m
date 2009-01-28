Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbZA1U7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbZA1U7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZA1Urq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:47:46 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52267 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbZA1Urp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:47:45 -0500
Date: Wed, 28 Jan 2009 21:49:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
Message-ID: <20090128204927.GA28782@uranus.ravnborg.org>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <1233106614.3256.6.camel@localhost.localdomain> <200901281337.52294.arnd@arndb.de> <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick> <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:44:13AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 28 Jan 2009, Harvey Harrison wrote:
> > On Wed, 2009-01-28 at 09:48 -0800, H. Peter Anvin wrote:
> > > 
> > > In general, no.  The byteswap API is a legacy exception.
> > 
> > But now that swab.h has been separated out, we could just stop exporting the
> > asm/swab.h bits while still providing a generic C-based implementation to
> > userspace.
> 
> Well, the _reason_ the byteswap stuff has been interesting to user space 
> is that the kernel did it better than the alternatives. Rather than having 
> purely "work with big-endian data" (the networking htonl etc functions), 
> the kernel had good and fairly optimized handling of various different 
> forms of byte order handling.
> 
> Which is why people wanted to use it in the first place - and which is why 
> then doing just the generic C-based thing doesn't really fix the issue. 
> Things may compile, but they kind of lost the point.

The right fix then is to provide these optimized versions as part
of their libc variant, not to keep exporting our internal
versions to userland. Because the internal version may
be subject to runtime patching and api changes etc.

	Sam
