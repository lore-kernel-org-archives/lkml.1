Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697Ab0AZQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0AZQ3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573Ab0AZQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:29:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab0AZQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:29:16 -0500
Date: Tue, 26 Jan 2010 08:28:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Stezenbach <js@sig21.net>
cc: Renzo Davoli <renzo@cs.unibo.it>, Mark Wielaard <mjw@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <20100126160811.GA3242@sig21.net>
Message-ID: <alpine.LFD.2.00.1001260816000.3574@localhost.localdomain>
References: <20100123114729.GA7828@redhat.com> <20100123194820.GM21263@thunk.org> <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain> <20100125170254.GB22862@redhat.com>
 <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain> <1264451453.3028.59.camel@springer.wildebeest.org> <alpine.LFD.2.00.1001251236160.3574@localhost.localdomain> <20100126000237.GA15936@cs.unibo.it> <alpine.LFD.2.00.1001251605320.3574@localhost.localdomain>
 <20100126160811.GA3242@sig21.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Johannes Stezenbach wrote:
> 
> 1. If you'd merge utrace + ptrace-on-utrace, but never anything else
>    which uses the utrace API, wouldn't it still be an improvement?

I already said earlier that I'd be perfectly happy to merge utrace code, 
as long as it was clear that I'm not merging a platform for crazy work. 
IOW, the end result might be merging 99% of the code, but I want to set 
peoples _expectations_ right. I'm not at all interested in merging stuff 
that has various exported helper functions for people doing random things, 
but I could happily merge stuff that cleans up internal implementation.

> 2. A well defined utrace API makes debugging code more hackable, thus more
>    likely that someone might come up with a brilliant killer debug
>    feature in the future.

I don't really agree. 

Clean code makes things easier to improve, and maybe utrace cleans thigns 
up. But defining new API's makes me very worried, and quite frankly, the 
last thing I ever want to see is a new interface that out-of-tree modules 
starr using for random hacking.

So I'd be much happier without the whole utrace kernel interface and 
callbacks, and very much would want to avoid the whole issue of plugins. 
I'd like to see ptrace improvements - not something else.

In other words, I'd much much rather keep the utrace thing _internal_ to 
ptrace. If people have performance complaints about ptrace, let's look at 
fixing those _as_such_, rather than look at new modules etc.

> BTW, the ptrace improvements discussed elsewhere in this thread
> (like using an fd intead of signals/wait) are orthogonal
> to utrace, no?  IMHO it's a seperate discussion.

Largely, yes. Tied together to some degree of course, but the whole issue 
of code cleanup can be seen as a reasonably independent first step (while 
moving to a fd-based interface should probably not be done without some 
cleanup first, so they _are_ somewhat tied together).

		Linus
