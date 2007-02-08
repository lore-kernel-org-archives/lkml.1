Return-Path: <linux-kernel-owner+w=401wt.eu-S1423315AbXBHWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423315AbXBHWxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423338AbXBHWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:53:41 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35090 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423315AbXBHWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:53:41 -0500
Date: Thu, 8 Feb 2007 23:53:09 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702082335150.14457@scrub.home>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
 <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> Historically, people used to do:
>  - /bin/sh was the "standard shell" (bash)
>  - /bin/[t]csh is what clueless weenies use for interactive work.
> 
> (Yeah, I'm not a [t]csh fan ;)
> 
> And you did break that.
> 
> It's quite possible that all modern distributions will install /bin/bash 
> as a link to /bin/sh, but I don't see the point of that particular change. 
> We aren't even all that bash-centric any more. If you have a 
> POSIX-compatible shell in /bin/sh, it really _should_ work. It just can't 
> be something really broken.

I don't quite understand, the Makefile doesn't care anymore about /bin/sh 
with this patch, the Makefile checks only for $BASH and /bin/bash 
(equivalent to adding "#! /bin/bash" to scripts) and if the latter fails 
it's possible some of our scripts will fail. We could make sure that all 
our scripts are POSIX clean, but is it really worth the effort? It would 
make casual kbuild hacking only even more difficult, as one has to check 
it works with the various shells.

> > - proper quoting
> > - proper indentation
> 
> One thing I'm wondering about is whether we could have a "does this warn" 
> test. I guess you can do it with -Werror, but it might be nice to have 
> some tests for "does the -Wxyzzy flag warn also for proper code"

Adding something like try-compile should be possible, but we should be 
careful with this, the more checks we add the more work is done at every 
make invocation.

bye, Roman
