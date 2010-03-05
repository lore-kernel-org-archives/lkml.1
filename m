Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0CEQJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:09:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab0CEQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:09:33 -0500
Date: Fri, 5 Mar 2010 08:07:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: daniel@fooishbar.org, alan@lxorguk.ukuu.org.uk, skeggsb@gmail.com,
       airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305.072612.186421758.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.1003050754210.3788@localhost.localdomain>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk> <20100305.063718.211238119.davem@davemloft.net> <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, David Miller wrote:
> 
> In fact, I argue that the moment nouveau went into Fedora and
> was turned on by default, the interfaces needed to be frozen.

Now, I agree that that would have been the optimal setup from a testing an 
user standpoint, but I think it's a bit too strong.

Things don't need to be "frozen", but flag-days need to be avoided. The 
problem with flag-days is not so much that they need new support code: 
downloading a new version of something like X is not a huge issue. But 
flag-days work both ways: it's not just that you have to download a new 
version, it's that you can't go _back_ either - not even a little bit.

For example, I can now test my new kernel, but if it turns out that there 
are problems with it, I'm now officially screwed. I can't go back and rely 
on even the stable distro kernel, like I'm used to ("ok, that _really_ 
didn't work, but happily I didn't remove the distro kernel, so I'll just 
reboot with that"). And I certainly can't bisect without major problems.

And Fedora can't install the new libraries, because they won't work with 
their own old kernels either. So it effectively causes a version freeze: 
it looks like F12 will simply _never_ be able to support a 2.6.34 kernel, 
because if they do that, then everybody who gets the new packages (and has 
a nvidia graphics card) will now be stuck.

So flag-days really are bad. They're bad for users, they're bad for 
distributions, and they're eventually bad for developers too because now 
they lose a lot of every-day testing. Some day, F13 will come out, and the 
_only_ testing all the new code ever got was the (relatively small) 
rawhide community, and the kernel crazies who did things manually.

But even if you can't guarantee backwards compatibility, if you avoid the 
flag-day, and can have a new version of the environment that can handle 
both the old and the new model, you _could_ install that on F12 (before 
switching kernels), and not be in that effective version-freeze.

Yeah, you'll still have a dependency chain, but it will be a one-way one, 
so you're not stuck. As long as you have the newest vesion of whatever 
libraries or support, you can go back-and-forth and test development 
systems.

And we do that for the kernel in many other respects. We require that you 
have a "recent enough" compiler, for example. So there are already lots of 
those one-way dependencies where we're not infinitely backwards compatible 
with user space, but we've been pretty good at not having flag-days.

				Linus
