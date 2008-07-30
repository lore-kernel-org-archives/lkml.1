Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYG3Sj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYG3Sj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYG3SjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbYG3SjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:39:19 -0400
Date: Wed, 30 Jul 2008 11:35:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [GIT PULL] x86: use arch/x86/include
In-Reply-To: <4890B153.6050305@zytor.com>
Message-ID: <alpine.LFD.1.10.0807301125090.3334@nehalem.linux-foundation.org>
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu> <4890B153.6050305@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, H. Peter Anvin wrote:
> 
> Git *should* be able to track those changes across a rename and even with a
> rename on one branch and changes on another; in my experience it works well
> for filename renames, but git doesn't understand directory renames at all, so
> new files do have to be moved to their new locations manually.

Yes. Note that this is true only for merging (and some operations that can 
use the merge infrastructure, like cherry-picking). It's obviously not 
true for pure patches that are just pending in mailboxes etc.

The big x86 architecture rename (i386->x86) had some problems just due to 
the huge number of files involved, but the include directory should not 
just be easier, on the git side we also fixed some of the scalability 
issues we had with lots of renames.

[ However, fairly old versions of git may still have trouble due to 
  limiting rename detection to a smallish number of files (ie 100 or 
  something).

  Note, though, that the only person who needs a reasonably modern version 
  of git is the person actually doing any merges that take renames into 
  account. So "normal users" can use old versions without even realising. 

  And we're really talking about git versions about a year old - the whole 
  arch/x86 rename thing was June last year. So by "modern" I definitely 
  don't mean "last week", but "updated in any kind of reasonable manner", 
  which I assume everybody involved in any x86 merging would have ]

> > I missed the discussion on this, what's the point of renaming all these
> > files?
> 
> I know there has been talk about this on and off for a long time (to get all
> the arch code into arch/).  I don't know if there are any mechanical reasons
> for it, on top of that.

My big reason is that it makes it much easier for me to see when merges 
only touch a specific architecture (git will always sort things by 
pathname, so if the first pathname is arch/xyz/something and the last one 
is arch/xyz/somethingelse, then I don't even need to look any closer). It 
also makes it much nicer for my statistics generator.

IOW, it helps the "overview" people, probably not so much anybody else. 

It also ends up allowing some extra flexibility, ie we can put 
architecture header files in other places than <asm/xyz.h> (eg the whole 
<mach/xyz.h> thing), so there _are_ technical reasons for it, but at least 
to me those are just frosting on the cake.

			Linus
