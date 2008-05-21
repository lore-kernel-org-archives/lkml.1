Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbYEUSkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbYEUSkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYEUSj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:39:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbYEUSj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:39:56 -0400
Date: Wed, 21 May 2008 11:39:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Takashi Iwai <tiwai@suse.de>, Rene Herman <rene.herman@keyaccess.nl>,
       alsa-devel@alsa-project.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
In-Reply-To: <alpine.DEB.1.10.0805211121170.6420@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0805211128410.3081@woody.linux-foundation.org>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz> <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz> <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de>
 <48341DF5.4090307@keyaccess.nl> <s5habijww7r.wl%tiwai@suse.de> <48344271.3090700@keyaccess.nl> <s5hy763ve5n.wl%tiwai@suse.de> <alpine.LFD.1.10.0805210908460.3081@woody.linux-foundation.org> <s5htzgrvbvo.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211003170.3081@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805211043590.3081@woody.linux-foundation.org> <alpine.DEB.1.10.0805211121170.6420@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, david@lang.hm wrote:
> 
> one thing that you have missed in your explination in this thread (although
> you have made the point in other threads) is that subsystem maintainers have
> the fear that there are other changes that will interfere with their stuff and
> want to catch it early.

Yes. 

However, that's not just a "my tree" issue. In fact, quite often other 
trees are more interesting from that angle: for driver subsystems like 
sound, the changes in Greg's driver core git tree may actually be oftne 
more relevant and give more of a heads-up than looking at my tree.

> per your instructions in prior threads, what they should do is to have a
> seperate branch on their system that they use as a throw-away branch to pull
> from your tree, and from their tree to spot problems. As they find problems
> they can then address them (cherry pick, or whatever)

Yes. Doing throw-away merges is a great way to test not just whether there 
might be actual merge conflicts, but also to just test that things work 
together.

And even if you want to concentrate your *development* on just 
ALSA-specific stuff, you may well want to also test all the changes that 
have gone upstream from other projects (and often do that _together_ with 
the changes you have developed yourself). And again, for this kind of 
testing, doing a throw-away merge to see how it all works together is 
fine.

> so it's not that the ALSA people should only look at your tree at the merge
> points, it's that they shouldn't pollute their tree that they are going to
> publish to you with this checking.

Yes. In general, it's a great idea to have "test trees" that aren't really 
for development, but for testing. That's obviously what 'linux-next' does, 
but it's something any tester can do (and it doesn't even have to imply 
any developer skills, although it would generally require at least some 
comfort with git).

That said, at least as far as I'm concerned, when I pull from some 
subsystem tree, the thing I really want to know is that the state of that 
tree is stable on its own. IOW, if the merge itself introduces some subtle 
bug, that is not only fairly unusual, but it's also something that should 
not be seen as a bug from the tree I pulled - it's just bad luck. 

So a submaintainer should care *most* about the fact that his/her tree is 
stable on its own. Problems that happen when multiple development trees 
are merged should be the secondary concern. I'd rather have people test 
their _own_ code really well, than spending lots of time trying to test 
every possible combination with other peoples trees.

			Linus
