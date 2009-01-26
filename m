Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZAZWUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZAZWUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZAZWU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:20:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZAZWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:20:27 -0500
Date: Mon, 26 Jan 2009 14:19:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm-fixes
In-Reply-To: <alpine.LFD.2.00.0901261356150.3465@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901261411310.3465@localhost.localdomain>
References: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie> <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain> <21d7e9970901261344v2909cc61m42f32f2a434df0c4@mail.gmail.com> <20090126215235.GA10484@uranus.ravnborg.org>
 <alpine.LFD.2.00.0901261356150.3465@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jan 2009, Linus Torvalds wrote:
> > 
> > There must be easier ways to do so I think.
> 
> Um. Yes. Something like
> 
> 	git am -s -C1
> 
> which ends up requiring just a single line of context for the patch to 
> apply, exactly like the GNU 'patch' program.
> 
> The difference being that GNU patch does that incredibly broken thing by 
> default, and makes it easy to apply a patch that was already applied quite 
> by mistake, because it still works. Git will require you to say explicitly 
> that it's ok to have just a single line of context.

Btw, I _really_ don't want people using -C1 by default. It really is a 
broken default, and there is a reason why I dislike GNU patch for applying 
almost any patch that makes any sense what-so-ever.

So please work with the stricter git defaults. You can still get patches 
that silently apply even if they don't work (there's nothing magical about 
three lines of context - a patch may still apply in the wrong place), but 
it's a lot harder to get those silent screw-ups.

Then, when the strict model doesn't work, take a look by hand, and try to 
figure out why it didn't work. If you decide that you really do want to 
apply the patch, and the changes near-by that causes it to not apply any 
more were really not relevant and don't affect the behaviour of the patch, 
_that_ is when you can use -C1 and --whitespace=fix etc to make it apply 
despite not being a 100% match.

So don't use -C1 and whitespace-fixup blindly. That way lies madness. It 
may _seem_ to be much easier, and yes, 95% of the time it will do the 
right thing, but when it doesn't, it silently does bad things. Please only 
use those flags when you've literally spent a few seconds of a real human 
brain to look at why they are needed.

			Linus
