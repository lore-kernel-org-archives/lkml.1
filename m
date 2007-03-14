Return-Path: <linux-kernel-owner+w=401wt.eu-S1030887AbXCNUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030887AbXCNUfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXCNUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:35:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030887AbXCNUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:35:00 -0400
Date: Wed, 14 Mar 2007 21:34:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314203454.GD376@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org> <20070314195916.GA5674@elte.hu> <20070314200704.GB376@one.firstfloor.org> <20070314201944.GA11583@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314201944.GA11583@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the basic dynamics of legacies does not change if we have only 50% of 
> them: right now x86_64 is just growing its own set of legacies, at the 
> same rate as i386 did it 10 years ago. 

Modern system are much more similar to each other than older systems
due to Windows forcing them and they are using much more hardware. 

For example we'll never have the tons of weird APIC errata again old 
platforms had.

And the 64bit APIC code is already much cleaner because of this
and this made new work (like Eric's rework which only happened
partially on i386) much easier.

Also 64bit doesn't support any weirdnesses like visws,voyager
which probably should have been ripped out long ago because
they cause large issues in the code and are practically unused
(I bet both have userbases I can count on my fingers) 

> practice: those legacies will quickly necessiate the _same_ kinds of 
> abstractions that allow the flexible injection of hardware-dependent 
> quirks. In another 5 years the x86_64 tree will end up looking and 

That's not my experience.

> behaving _just like the i386_ tree, the only difference will be less 
> compatibility. (In fact, it will likely look worse because currently our 
> efforts are 50% split between i386 and x86_64, and the random 

That's also not how it works. Typically bug fixes are applied to both.

> Also, 90% of our users are still running 32bit kernels _even on 64-bit 
> capable hardware_, so we might as well prepare ourselves for a really 
> long march towards a pure 64-bit world. (Which will likely never come.)

32bit is not the problem, the problem is old platforms/weird not quite
PC platforms (which don't exist in the 64bit world)/very old CPUs.
32bit has some ugly legacies  (like vm86) but they are handleable.
The old bugs aren't imho.

When a new unified port was done it could be done for modern x86 only,
with arch/i386 kept for the old legacy stuff.
That would be fine for me. The trouble is just that I'm not sure
that distributions would actually ship it e.g. because not supporting
P5s anymore might be still too radical. And if it was not shipped
then it would be useless.

Besides it's would be a lot of work and frankly not very interesting work.

-Andi

