Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZGAIzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZGAIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZGAIzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:55:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52581 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZGAIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:55:45 -0400
Date: Tue, 30 Jun 2009 08:27:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630062720.GA1351@ucw.cz>
References: <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624145615.2ff9e56e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This is not a new concept. oom has never been "immediately kill".
> 
> Well, it has been immediate for a long time.  A couple of reasons which
> I can recall:
> 
> - A page-allocating process will oom-kill another process in the
>   expectation that the killing will free up some memory.  If the
>   oom-killed process remains stuck in the page allocator, that doesn't
>   work.
> 
> - The oom-killed process might be holding locks (typically fs locks).
>   This can cause an arbitrary number of other processes to be blocked.
>   So to get the system unstuck we need the oom-killed process to
>   immediately exit the page allocator, to handle the NULL return and to
>   drop those locks.
> 
> There may be other reasons - it was all a long time ago, and I've never
> personally hacked on the oom-killer much and I never get oom-killed. 
> But given the amount of development work which goes on in there, some
> people must be getting massacred.
> 
> 
> A long time ago, the Suse kernel shipped with a largely (or
> completely?) disabled oom-killer.  It removed the
> retry-small-allocations-for-ever logic and simply returned NULL to the
> caller.  I never really understood what problem/thinking led Andrea to
> do that.

I guess he was trying to get huge 32bit highmem machines to work... On
such systems, kmalloc failures will eventually get you...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
