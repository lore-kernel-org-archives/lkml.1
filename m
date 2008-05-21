Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbYEUVpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbYEUVpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYEUVpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:45:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbYEUVpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:45:06 -0400
Date: Wed, 21 May 2008 14:44:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
In-Reply-To: <s5hzlqjz74d.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Takashi Iwai wrote:
> 
> One thing that annoys me sometimes is that the sound driver codes are
> on a different subdirectory than other normal drivers, namely under
> /sound. 

I would certainly personally like drivers/sound more, and the placement at 
the top level is actually because the sound maintainers wanted it that 
way, probably to avoid the confusion with the old OSS drivers that used to 
live in drivers/sound.

I forget the exact details. It's been many many years, and there may have 
been some real technical issues too. But basically sound/ was created when 
ALSA was first merged, and we had a lot of renames from drivers/sound/xyz 
to sound/oss/xyz.

(It may have been that it was simply easier to have a new subdirectory 
than it was to re-use the old one. In fact, with BK and patches, that 
was generally the best way to guarantee that the rename-tool did the 
right thing, so details like that may have been part of it. I forget).

So I would personally certainly not mind somebody doing a 

	git mv sound drivers/sound
	.. edit makefiles and Kconfig files appropriately ..
	git commit -a

and it wouldn't be a problem for git (ie the repository wouldn't grow or 
anything like that).

And doing pure renames (and not editing up a lot of actual files) would 
make rename detection easy for subsequent merges. The only real pain of 
renames is the efficiency of detection when you have lots and lots of 
files, but if the SHA1 of the file stays the same for the big bulk of 
them, that makes the problem basically go away (it becomes a much more 
interesting problem when you move hundreds of files around and _also_ edit 
the bulk of them - even if the edits are trivial, now you need to 
actually look at the contents to figure out the renames).

> If I understand correctly, with git, we can move the files in
> relatively little costs.  So, what about moving sound/* back to
> drivers/sound/* or drivers/media/sound/*?

I'd personally prefer just drivers/sound - no point in making it any 
deeper than that. 

But I'd not be much affected myself, so I don't much care. I do agree that 
it would fit better under drivers/, but it's really mostly up to you guys.

> Of course, the primary question is whether it's really worth.
> The obvious drawback is that patches won't be applicable after the
> move.

Well, git merging is actually pretty good at this, so you can apply the 
patches to the old release and then merge it, and it will do the right 
thing (perhaps not for newly created files, but that's pretty easy to fix 
up). 

Also, even if you keep it as patches, as long as you move the whole 
subdirectory, then fixing up the patch is just a trivial 
search-and-replace, so I doubt it would be a big issue.

But it's really up to you guys.

Me personally, I've been more irritated by include/asm-xyz vs arch/xyz. It 
would be so nice if all the arch-specific changes woudl always show up 
under arch/ (both from a statistics standpoint, and just because then a 
diffstat really shows arch-specific stuff really obviously, and sorts all 
the arch-specific stuff together).

		Linus
