Return-Path: <linux-kernel-owner+w=401wt.eu-S1945894AbXC2W2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945894AbXC2W2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945895AbXC2W2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:28:35 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38066 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945894AbXC2W2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:28:34 -0400
Date: Fri, 30 Mar 2007 00:28:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Inlining can be _very_bad...
Message-ID: <20070329222832.GE14134@stusta.de>
References: <20070329011838.6e832615@werewolf-wl> <20070329175254.GC14134@stusta.de> <20070330000111.620aaaab@werewolf-wl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070330000111.620aaaab@werewolf-wl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:01:11AM +0200, J.A. Magallón wrote:
> On Thu, 29 Mar 2007 19:52:54 +0200, Adrian Bunk <bunk@stusta.de> wrote:
> 
> > On Thu, Mar 29, 2007 at 01:18:38AM +0200, J.A. Magallón wrote:
> > > Hi all...
> > > 
> > > I post this here as it can be of direct interest for kernel development
> > > (as I recall many discussions about inlining yes or no...).
> > > 
> > > Testing other problems, I finally got this this issue: the same short
> > > and stupid loop lasted from 3 to 5 times more if it was in main() than
> > > if it was in an out-of-line function. The same (bad thing) happens if
> > > the function is inlined.
> > >...
> > > It looks like is updating the stack on each iteration...This is -march=opteron
> > > code, the -march=pentium4 is similar. Same behaviour with gcc3 and gcc4.
> > > 
> > > tst.c and Makefile attached.
> > > 
> > > Nice, isn't it ? Please, probe where is my fault...
> > 
> > The only fault is to post this issue here instead of the gcc Bugzilla.
> 
> Sorry, my intention was just something like 'take a look at your
> reduction-like code, perhaps its sloooow', something like checksum
> funtions in tcp or raid that are inlined expecting to be faster
> and in fact they are slower...

Unless a function that has more than 1 caller is very tiny or reduces at 
compile time to a very tiny rest, it's not expected that inlining was 
faster on current CPUs.

But most times that's already only up to the compiler - e.g. current gcc 
versions already automatically inline all static functions with only 
1 caller.

> > In your example the compiler should produce code not slower than with 
> > the out-of-line version when inlining. If it doesn't the bug in the 
> > compiler resulting in this should be fixed.
> 
> That's what I expected, but...
> Going to gcc bugzilla...

Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

