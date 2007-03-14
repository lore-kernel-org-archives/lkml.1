Return-Path: <linux-kernel-owner+w=401wt.eu-S1161295AbXCNOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161295AbXCNOqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXCNOqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:46:40 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:55785 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313AbXCNOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:46:38 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070314134112.GB13486@elte.hu>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <1173879210.31159.30.camel@localhost.localdomain>
	 <20070314134112.GB13486@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 10:46:17 -0400
Message-Id: <1173883577.31159.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 14:41 +0100, Ingo Molnar wrote:

> hm. Do you have any numbers handy - what is the end-result of your 
> unification work, how many lines of code were unified, compared to the 
> total body of code in i386 and x86_64?

Well, I wasn't combining code that wasn't already combined :)

Just moving code that was referenced by another arch to a common
directory that showed the code is shared.

So, I moved a total of 44 files that were shared. Some of these were in
places where a full directory was shared (the mtrr code). And this
doesn't count the Makefiles and Kconfig files that were also modified.

There were only three files with the 
#include "../../<arch>/<path-to-file>" code.
These three where early_printk.c, tsc_sync.c and msr-on-cpu.c.
The rest is referenced by the Makefiles. This still doesn't make it easy
to find functions via TAGS or search scripts.

If you looked at the 18/18 patch, it has a list of the moved files, with
the exception of the speedstep-lib.h, which was moved in it's own file,
and those that referenced that header.


> symbolic links perhaps? In that case i'd also introduce a common naming 
> scheme: x86_early_printk.c - to make sure we know it right away that 
> those files are bi-arch.

Does the Linux code tree already support sym links? IOW, are there
already sym links in the code tree? (/me probably should just look ;)

So should we have an effort to label the shared code that's already
shared.  As Andi stated, he doesn't like "large scale" renaming since
that doesn't "fix a single bug", and will only "just cause pain".
Although I disagree if in the long run it will make it easier to work
with.  Once one knows about the crazy linking going on then it's not
much of a problem, but what about all those that will have to go through
this learning curve.

The problem I have with the current approach is that it just isn't
clean.  Yes it "works", but it still is a hack.  And if I do need to
write code that will be shared among the two archs (still don't know for
sure if this will be the case), I would like to have a clean method in
doing it.  I don't care what the final solution is, as long as it is
clean and not a hack.

-- Steve


