Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZAZWI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZAZWI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZAZWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:08:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbZAZWIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:08:46 -0500
Date: Mon, 26 Jan 2009 14:08:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm-fixes
In-Reply-To: <20090126215235.GA10484@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0901261356150.3465@localhost.localdomain>
References: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie> <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain> <21d7e9970901261344v2909cc61m42f32f2a434df0c4@mail.gmail.com> <20090126215235.GA10484@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jan 2009, Sam Ravnborg wrote:

> > 
> > Well I'm not 100% sure what happened for this patch, I suspect,
> > jbarnes sent patch a week
> > or two ago, it misapplied against the tree I had currently when
> > applied with git-am, it didn't work so I hand
> > applied the patch with patch and then did git commit
> > --author="jbarnes" as he did write it, I just munged it.
> > 
> > Now I'm unsure how I should best handle this, in a world where I can
> > devote a lot more time to
> > maintaining this, I would sent Jesse a mail saying, rebase, he'd reply
> > with a rebase and I'd apply it,
> > however I generally find it easier to just fix this stuff up on the
> > run as its synchronous. Should
> > I be specifying a date somewhere in the commit message?
> 
> My simple way to deal with this is to:
> 
> 0) save the mail
> 1) fix subject and changelog and add my Signed-off-by:
> 2) apply the patch somehow
> 3) replace the origianl patch in the (saved) mail
> 4) git reset --hard (or patch -p1 -R < saved-mail)
> 5) git am <saved mail>
> 
> There must be easier ways to do so I think.

Um. Yes. Something like

	git am -s -C1

which ends up requiring just a single line of context for the patch to 
apply, exactly like the GNU 'patch' program.

The difference being that GNU patch does that incredibly broken thing by 
default, and makes it easy to apply a patch that was already applied quite 
by mistake, because it still works. Git will require you to say explicitly 
that it's ok to have just a single line of context.

Anyway, on its own I wouldn't have reacted - sure, you can just do the 
whole "use patch and then commit as another user" and the times will be 
odd, but the *big* issue with Dave's pull-request was that there were 
multiple cases of just clearly lost information.

In other words, I don't care about the dates. I don't care _how_ you do 
your git commits. And I don't even care if you use the broken "patch" 
command that accepts random line noise as a patch, as long as you check it 
later.

But I _do_ care when it looks like somebody is using a bad process that 
clearly isn't working, and that clearly is dropping things on the floor. 
If it's a "odd things happens very occasionally because I had to use a 
special sequence for it", that's fine.

So when 3 out of 8 patches were somehow missing information (two without 
sign-offs, and the third that had a sign-off but was obviously also done 
by the odd sequence that dropped the timestamp), that's no longer just 
some occasional issue and is a more endemic process problem.

			Linus
