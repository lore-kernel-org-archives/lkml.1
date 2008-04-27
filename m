Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYD0Lch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYD0Lch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761076AbYD0Lc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:32:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44165 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYD0LcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:32:25 -0400
Date: Sun, 27 Apr 2008 14:31:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427113158.GY2252@cs181133002.pp.htv.fi>
References: <20080427105100.GA14795@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427105100.GA14795@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 12:51:00PM +0200, Sam Ravnborg wrote:
> Fix the OPTIMIZE inline functionality such that it can be used
> by all architectures.
> To use it the arch maintainers shall add a
> "select HAVE_OPTIMIZE_INLINING" in their arch specific
> Kconfig file.
>...

My opinion on this is still:
"OPTIMIZE" means "work around bugs in the kernel".

Bugs of the following kinds:
- usage of "inline" in .c files (it should virtually never be used there)
- too big functions in header files

And this "inline optimization" reverts only the effects of some of these 
bugs.

And if the wrong code gets not inlined we can even get size increases at 
some places.

Denys and Ilpo have already done some work in fixing such bugs.

After the dust of this merge window has settled I'll try to get us a 
similar result without this "optimization".

> 	Sam
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

