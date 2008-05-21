Return-Path: <linux-kernel-owner+w=401wt.eu-S936383AbYEUSMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383AbYEUSMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbYEUSMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:12:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbYEUSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:12:22 -0400
Date: Wed, 21 May 2008 11:11:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
cc: Rene Herman <rene.herman@keyaccess.nl>, alsa-devel@alsa-project.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
In-Reply-To: <alpine.LFD.1.10.0805211003170.3081@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805211043590.3081@woody.linux-foundation.org>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz> <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz> <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de>
 <48341DF5.4090307@keyaccess.nl> <s5habijww7r.wl%tiwai@suse.de> <48344271.3090700@keyaccess.nl> <s5hy763ve5n.wl%tiwai@suse.de> <alpine.LFD.1.10.0805210908460.3081@woody.linux-foundation.org> <s5htzgrvbvo.wl%tiwai@suse.de>
 <alpine.LFD.1.10.0805211003170.3081@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Linus Torvalds wrote:
> 
> So merging on its own is not "wrong or evil" at all. Merging is a very 
> good operation to do, but *mindless* merging is bad. That's really all 
> that I'm really trying to argue against.

Btw, let me explain this another way.

I do a *lot* of merges as being an "upstream" person. Since 2.6.25, I've 
done something like 247 merges (and that's not counting the fast-forward 
ones). If you do

	git log v2.6.25.. -author=torvalds

you'll see pretty much just merges. It's simply what I do. I have a few 
fairly trivial patches every once in a while (although you almost have to 
add a "--no-merges" to filter out the merges to see them), but doing 
merges is what I do most.

So why would I tell others to not merge, when I've done several hundred 
merges in just the last month myself? Isn't that really hypocritical of 
me? 

The symmetry breaking comes from a few things:

 - the merges that "upstream" people do are generally smaller, but even 
   when they are large, they have a "theme".

   Most merges I do are fairly small, but even when they aren't (eg the
   network layer merge of all the thousands of commits that were pending 
   for when the merge window opened), they are _directed_.

   IOW, when upstream does a merge, it's hopefully (if the process works 
   correctly) going to be about a specific sub-area, even if that area may 
   be pretty big. So the merge has a very specific meaning: "I want to 
   pull in the changes to subsystem 'xyz'"

   In contrast, a merge that goes the other way (subsystem merging 
   upstream) generally doesn't get any particular directed development 
   changes, it just gets "everything else".

   This also explains why I can do merge summaries, and downstream people 
   generally can not. Look at my merges, and see how they say things like

      Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
    
      * git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6: (21 commits)
        [CIFS] Remove debug statement
        Fix possible access to undefined memory region.
        [CIFS] Enable DFS support for Windows query path info
        [CIFS] Enable DFS support for Unix query path info
        [CIFS] add missing seq_printf to cifs_show_options for hard mount option
	...

   iow, when upstream does a merge, it's simply different from when 
   downstream does one - thanks exactly to having a specific purpose.

 - I hopefully only merge "release points".

   I don't pull from people at random points. I don't pull daily, or even 
   weekly. I pull when a sub-maintainer asks me to pull, and I've tried to 
   teach people to think of their pull requests as literally being 
   "releases" of their tree. Because they effectively are!

   No, releases aren't perfect, and there will be bugs, but the same way 
   that I argued that maintainers should generally aim to pull from me 
   mainly at stable release points, I myself want to pull from downstream 
   only when there is _some_ reason to believe that it's a stable point.

   So this isn't really a "broken symmetry", but it looks different 
   because subsystem "releases" are smaller and happen more often than a 
   "whole kernel release".

 - My tree isn't so much a "development tree" as it is a "integration 
   tree".

   IOW, the biggest reason for my tree to exist in the first place is 
   exactly the fact that it gives people a place to go to see what the 
   "union" of the development is. In contrast, the reason people would go 
   to the ALSA tree, or the networking tree, or any of the other specific 
   trees is exactly because they don't want the union, but want to see 
   what's recent in that particular area.

   If somebody fetches the tip of the ALSA tree, they may expect 
   sound-related stuff to break, but you'd generally want to make sure 
   that the rest is as stable as possible (while not being _entirely_ 
   stale, of course!)

   If somebody fetches my tree, they want it all, and they *expect* to see 
   any breakage (and any new features) that everybody else could have 
   caused.

So the above hopefully explains why I do 350+ merges per release, but 
still have the gall to tell other people that they shouldn't merge too 
much.

[ The corrollary to this all is that when downstream does a merge, think
  about what the merge message can say. How would you descibe the merge? 

  Can you give a good description of what you merged, and why? That's one 
  thing that merging with releases can give you: you can say "merge with 
  release 'xyz'", and people actually understand the *meaning* of it. Your 
  merge message makes sense - and that implies that the merge itself 
  likely made sense.

  If you cannot explain what and why you merged, you probably shouldn't be 
  merging - that's a good rule of thumb right there! Maybe that rule in 
  itself should already be seen as sufficient ]

				Linus
