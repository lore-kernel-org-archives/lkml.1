Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0CEPyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:54:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab0CEPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:54:13 -0500
Date: Fri, 5 Mar 2010 07:53:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
In-Reply-To: <20100305100030.GA4970@Pilar.aei.mpg.de>
Message-ID: <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
References: <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
 <20100305074407.GC19703@elte.hu> <20100305100030.GA4970@Pilar.aei.mpg.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Carlos R. Mafra wrote:
> 
> Whereas everytime I wanted to do that with Xorg it was such a pain that
> I want to keep away from that mess.

Actually, take it from me: Xorg is _pleasant_ to test these days.

Ok, so that's partly compared to the mess it _used_ to be, but it's really 
night and day. The whole build system was so incredibly baroque and heavy 
that you really had to understand it deeply if you wanted to do anything 
fancy.

And the non-fancy alternative was to just build the whole thing, which 
took _hours_ even on fast machines because the build system overhead was 
near-infinite (I dunno, maybe parallel builds could be made to work, but 
it took more brain-power than I could ever put into it).

These days, there's a few dependencies you need to know about (I do agree 
that from a user perspective the thing might have been made a bit _too_ 
modular) but they are generally fairly trivial, and there are scripts to 
download all the drivers and misc utilities needed.

And the modularization often works: you can often (but by no means always; 
it does require that the other parts are "close enough" and that there 
haven't been any major changes) just have the source code to the one 
driver you care about, and recompile and install just that _single_ 
driver.

I've done it. It's becautiful when it works. And it's a major pain when 
you notice it didn't work, and you needed to get the whole server and 
libdrm trees after all, and now you're not replacing single files any 
more and have little idea what it will stomp on in your distro.

So it really is very convenient when it works. And X doesn't have 
thousands of drivers like the kernel (maybe 10-15 that people care about 
at all, and about three or four that actually really matter), and there 
are seldom huge changes that affect them all, so the modularization 
doesn't turn totally crazy.

So I can see where the Xorg people really like their new modular world. It 
does work, it's _sooo_ much better than the mess it used to be, and the 
problems are fairly manageable when they do happen. 

The modular approach really works very well when there aren't lots of 
interactions between the modules, and when the modules are few enough that 
it isn't a total disaster (imagine doing a change that requires changes to 
all drivers in Xorg, vs doing a change that requires changes to all 
drivers in the kernel - the modular approach simply wouldn't work for the 
latter case, because you'd spend all your time just chasing down external 
users).

That said, the _one_ thing I really wish could be done would be to make it 
easier to install things side-by-side - and with the modularization, you 
really do want to do it module-by-module. One of the things that makes it 
so easy to test the kernel is that when you install one kernel, that 
doesn't affect the others, and you can go back-and-forth in testing. 
That's really important, because it makes testing trivial and non-scary 
even in the presense of issues that makes the new version unusable.

				Linus
