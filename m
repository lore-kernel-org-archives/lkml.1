Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0CEAJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:09:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab0CEAJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:09:01 -0500
Date: Thu, 4 Mar 2010 16:08:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <20100304103655.0b14343f@jbarnes-piketon>  <20100304103929.6eb81d45@jbarnes-piketon>  <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
  <20100304105624.70fe845e@jbarnes-piketon>  <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>  <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>  <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Dave Airlie wrote:
> 
> Speaking as distro maintainer here,
> 
> No because we've got versioned interfaces and we are happy to support them
> yes it would be nice sometimes to dream about this, but its a major explosion in
> the testing matrix. You have to realise the more codepaths a distro ships, the
> more codepath it has to keep track off for security issues, for bug fixes, etc.

I think you're missing the whole point here. There's no new and complex 
"testing matrix". You only ever test the newest version, so there's no 
additional testing.

Here's the "inductive proof":

 - if the version number doesn't change, you aren't doing anything that is 
   at all different from what you already do.

 - if the version number _does_ change, it does so only because you 
   updated both the kernel component and the libdrm component together, 
   and you test them together - exactly like you already do.

So there is absolutely no difference for you. In either case, you only 
ever test paired up versions. If you make a new version, it will never 
_ever_ interact with old versions. There's no new complex testing needed.

The only thing it allows is for you to have multiple kernels installed 
simultaneously - and be able to _use_ them all. Which is something you 
already do.

And which the current model doesn't allow for. You may have three 
different kernels installed, but if libdrm got updated with a version 
change, only one of those kernels will actually _work_.

> When to we decide to stop shipping nouveau_drv-0.0.13? when do we find
> out it has a security issue?

Irrelevant and total red herring. You never care about older versions, 
since if people have updated, they are running the newer version.

So the older versions are there purely so that you _can_ have multiple 
different kernels, and so that your _developers_ can compile new kernels 
for older distributions. They aren't relevant for the case you point to: 
if somebody is just doing "yum update", they'll get - and use - the newer 
version anyway.

> Here's the thing, distros are trying to ship an OS with a consistent set 
> of packages, not a pick-n-mix.

But here's the thing: if you expect people to do development, they _need_ 
to be able to mix things. A kernel developer needs to be able to update 
their kernel. And a kernel _tester_ needs to be able to test that kernel.

Seriously: what do you expect me to do right now in my situation?

I'm not going to release a kernel that I can't test. So if I can't get a 
libdrm that works in my F12 environment, I will _have_ to revert that 
patch that you asked me to merge.

Really. Look at it from my standpoint. Look at it from _any_ kernel 
developer standpoint. It would be totally irresponsible of me to release 
2.6.34 without even eating my own dog-food on my own main machine. Can't 
you see that this is obviously true?

So right now, I'm running with that patch reverted on that machine. I 
haven't committed the revert, and quite frankly, I'd really prefer not to. 
But the only way that "not revert" case can really happen is if there is 
some other way for me to have a working machine again.

Think about it. Tell me what the solution is.

		Linus
