Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXCOQsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXCOQsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030622AbXCOQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:48:47 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:54898 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXCOQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:48:46 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070315160648.GA11812@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
	 <45F96B57.10206@mbligh.org>
	 <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
	 <20070315160648.GA11812@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 12:47:44 -0400
Message-Id: <1173977264.7922.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 17:06 +0100, Andi Kleen wrote:

> Well I just see a lot of pain from these patches but I doubt 
> they will avoid any bugs. If people don't compile test both
> archs they will always likely break on another. There are lots
> of subtle dependencies that are not expressed in the pathname
> even after this intrusive operation (e.g. in the includes).
> 
> That's just how it is.

Or that's just how you see it.

Yes, if you don't compile and test on both it can always break on the
other arch. But this at least lets a developer know that what they are
modifying requires a compile and test on both. The current way is more
of a surprise that it breaks another arch.  You're changing a file in
arch/i386/... and you later get yelled at for breaking x86_64 ??  That's
not negligence, that's blame for being ignorant of the interlocking
dependencies. Where-as if you change the file in arch/x86 or
include/asm-x86, you had better test both architectures.

With the proposed patch set, what can break i386 by modifying something
in arch/x86_64, or what can break x86_64 by modifying something in
arch/i386? (not counting the unfinished pci shared code).

> 
> If the architecture merging was ever done it would be likely
> by extending arch/x86_64 to support (modern) 32bit. But this
> change doesn't bring us any step closer to that goal.

I'm not so sure about that. It at least gets people aware of the issues.
If you expect x86_64 to start encompassing 32bit, then at least have all
the files under arch/x86_64 and point the i386 there.  Create something
like a x86_common directory under arch/x86_64 and have that contain all
the code that i386 can also share.  Something that makes it cleaner and
not the total hacks that we have today.
 
> 
> I think it's just aesthetics -- i'm all for aesthetics but only 
> if it gives better software and doesn't impact other people who
> want to get something real done; neither of this is the case here.

Look, I sympathize with you. I'm not about to throw these patches at you
and then walk away. I'll take responsibility for them (I've been warned
by others that this will happen).  If there's issues and hardships that
cause you pain, feel free to kick some of the work over to me, and I'll
help you out. I'll even accept it when you write to me saying "here!
this is broken, and I think your arch/x86 crap is the cause. Fix it or
else!".

But I don't share your view that this doesn't give better software. And
I think what I've done was real work. Hey, I'm fine with keeping this in
arch/x86_64, in something called arch/x86_64/x86_common or something. As
long as there's a distinct separation of what is shared and obvious that
more testing needs to be done if modified.

-- Steve

