Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXH1R7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXH1R7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXH1R7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:59:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43078 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbXH1R7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:59:09 -0400
Date: Tue, 28 Aug 2007 19:59:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070828175904.GS26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <20070828003704.deed71ae.akpm@linux-foundation.org> <20070828144248.GR26410@stusta.de> <20070828170604.GA31284@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070828170604.GA31284@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 07:06:04PM +0200, Sam Ravnborg wrote:
> > 
> > It fixes a bug exposed by a -mm only patch, not by the net tree
> > (and 2.6.23-rc3-mm1 doesn't contain the net tree at all).
> > 
> > > But I'd like a better description, please.  Which "non-gcc parser" are we
> > > talking about here?  Something under ./scripts/.  Well, please identify it,
> > > and describe what the problem is, and how the proposed patch will address
> > > it.
> > >...
> > 
> > It's about parsers like the Sun C compiler and the C parser shipped 
> > with genksyms.
> 
> So it is about two bugs.
> 1) kbuild (genksyms) fails to generate CRC for some symbols
> 2) allow userspace to parse the header
> 
> As for 2 we already use sed to remove a lot of stuff in our headers
> so why do we use another approach here?

This time it's the other way round:

We need __extension__ only in userspace.

> As for 1 I will try to teach genksyms to accept __extension__ but
> it seems leess trivial than I expected (most be fooling myself somehow).

We anyway need a way to hide __extension__ from non-gcc userspace C 
compilers, and it can be hidden from genksyms the same way.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

