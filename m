Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYGQC5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYGQC5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYGQC5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:57:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbYGQC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:57:11 -0400
Date: Wed, 16 Jul 2008 19:56:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <200807161926.45975.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0807161948180.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org> <alpine.LFD.1.10.0807161751490.2959@woody.linux-foundation.org> <200807161926.45975.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Jesse Barnes wrote:
> 
> I'll dig around some more for git best practices too.  Based on what I've seen 
> of the x86 tree I don't have nearly enough branches

Don't worry about it. Start small. I think the x86 tree took up some 
pretty extreme limits, as can be seen by their 29-way merge or whatever it 
was. They also obviously have a lot more stuff going on than the PCI tree 
would be expected to have.

For most people, I'd expect that a small handful of branches is good. It 
might be just one, but it might be a couple of independent issues.

The point where a topic branch is _really_ useful is when you ask yourself 
whether that particular change is something that you (or somebody else!) 
might want to delay or test separately from some other change - that's 
when "oh, let's just use a separate branch for it" is really appropriate.

Len, for example, often did topic branches for individual bugzilla 
entries, and obviously for big conceptually separate things like ACPICA, 
which really _is_ a totally disjoint development track.

Other people, like rmk, use topic branches for particular hardware 
platforms.

On the other hand, if it's a trivial and obvious thing, there's no point 
in putting it into a separate branch. A number people who keep topic 
branches for all their major development then end up having a "misc" 
branch for just random things.

And remember: in git, topic branches are temporary things. You can rename 
them, you can delete them, you can ignore them. And before you've pushed 
things out, you can even decide to create a topic branch of a set of 
commits _after_ the fact. So you can commit _first_, and then decide that 
that commit was probably best to keep separate, so you create a topic 
branch with that commit on it, an go back to the pre-commit state on your 
regular branch.

BUT!

 - Not everybody _has_ to use topic branches. If you are maintaining 
   something that is very specific to begin with, _all_ your maintenance 
   is basically one topic to start with, so you'd never have separate 
   topic branches.

   The filesystem people, for example, do not tend to use topic branches 
   for this reason. They do their filesystem. They seldom have issues that 
   crop up on just certain platforms etc.

 - And more importantly - play around with it. Get used to it first. Look 
   at what other people do. Start small, with perhaps just one special 
   topic branch to test the waters with.

So don't worry _too_ much.

			Linus
