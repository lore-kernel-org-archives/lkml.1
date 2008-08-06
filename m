Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbYHFFPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbYHFFPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYHFFPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:15:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYHFFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:15:07 -0400
Date: Tue, 5 Aug 2008 22:14:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-rc2
Message-ID: <alpine.LFD.1.10.0808052157400.15995@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So it's been a week since -rc1, and -rc2 is out there.

There's a lot of random changes in there, and I'm hoping we're starting to 
calm down, but one particular _kind_ of random change is probably worth 
pointing out explicitly due to the things it can result in: the fact that 
a number of architectures ended up using the "lull" after -rc1 (hah!) to 
do the 'include/asm-xyz' => 'arch/xyz/include/asm' renames.

Now, that doesn't really matter for 99% of all people, but the very fact 
that there are a _lot_ of renames here (and more pending) can affect 
people who depend on git to do rename detection and merging of contents 
across renames.

So _if_ you use git to merge stuff, be aware that we've recently had more 
renames than the rename detection limit in git defaults to, and as a 
result, if you have a rename<->data change conflict, you may want to 
increase the default limit. Just add a 

	[diff]
		renamelimit=0

to your ~/.gitconfig to disable the limit entirely if you have lots of 
memory (or make it some high value like 5000 or something). The default 
limit is pretty low just to not cause problems for people who have less 
memory in their machines than kernel developers tend to have...

(Of course, you can just decide to do the merge resolution manually, but 
most people would prefer not to).

NOTE! For people who don't actually do development in git, and just use it 
to track the kernel tree by just updating from the same source all the 
time, this won't matter - you're not doing any merges, you're just fast- 
forwarding all the time and rename detection is immaterial since there can 
never be any conflicts to resolve.

Anyway, for somewhat the same reason, the diffstat isn't very readable. 
Even with rename detection enabled, there's a thousand lines of just 
things like

	rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/cache.h (88%)

etc (and obviously doing it _without_ rename detection is even less 
useful).

The dirstat (with rename detection on, so as to not show the movement as 
huge changes) is fairly usual, with most of the changes in drivers, along 
with an ext4 and xfs update making 'fs' show up pretty high too:

   3.9% Documentation/
   3.5% arch/mips/kernel/
   8.9% arch/mips/
   8.9% arch/
   4.0% arch/sh/
   4.1% arch/
  13.0% drivers/misc/sgi-gru/
  19.6% drivers/misc/sgi-xp/
  32.7% drivers/misc/
   4.2% drivers/net/wireless/
   7.6% drivers/net/
   5.8% drivers/regulator/
  56.7% drivers/
   8.6% fs/xfs/
  11.1% fs/
   6.5% include/

The shortlog is still a tad too big to make it on the list (again, as 
usual - normally I end up posting shortlogs for -rc3 and later when they 
become more manageable) but let me just say that it isn't really all that 
interesting. Theres' a lot of small changes here, but nothing that makes 
you go "Wow!". Not that there _should_ be anything like that in -rc2, of 
course, so I'm not complaining.

			Linus
