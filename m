Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZJGDZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZJGDZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZJGDZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:25:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbZJGDZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:25:19 -0400
Date: Tue, 6 Oct 2009 20:23:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
 <1254864803.6035.25.camel@pasglop>  <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain> <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Dave Airlie wrote:
> 
> Why don't you just have the kernel version Linux-commitid?

That's actually what I personally do 99% of the time. And, in fact, it's 
how CONFIG_LOCALVERSION_AUTO effectively works. It's very useful for doing 
things like

	gitk v$(uname -r)..

which really does work (well, apart from the "-dirty" case when I've 
compiled a dirty kernel that has something that isn't committed). Try it. 
It's a great way to see "what do I have in my current tree that I'm not 
actually running".

So with CONFIG_LOCALVERSION_AUTO, you can largely pretend that you really 
only have the git SHA1. The rest is "fluff" for people.

> why keep up the pretense that the 2.6.xx bit means anything outside of release?

Agreed. However, it _does_ mean something for releases.

And that is really how you should think of it. I update the kernel 
Makefile for releases, and nothing else. If you compile a non-release 
kernel, the version is meaningless - unless you have 
CONFIG_LOCALVERSION_AUTO.

> You could just have the tarball generation scripts make it into a 2.6.31 but
> for everyone else we never see it.

Well, about a year ago I actually considered generating the version 
entirely from the tags in the git tree, and do it entirely that way. 

The reason I didn't is that even if it only makes sense for releases, it 
is (a) tradition and (b) useful without (or across) SCM's and (c) human- 
readable. In fact, I tend to like seeing things like

	Linux version 2.6.32-rc2-00351-g58e57fb

in my dmesg outputs, because it does mean something _outside_ of just the 
pure "git version" (the '58e57fb' part is sufficient as far as git is 
concerned). It does have a very human-readable component to it: it's 351 
commits after 2.6.32-rc2.

So I literally think that our current CONFIG_LOCALVERSION_AUTO includes 
the best of both worlds. It has the "uniquely identifying" part, but it 
also has a part that is human-readable and useful for that reason.

			Linus
