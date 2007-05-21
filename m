Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXEUJTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXEUJTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXEUJTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:19:14 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:43494
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEUJTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:19:13 -0400
Date: Mon, 21 May 2007 02:18:48 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521091848.GB4593@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521075013.GA9419@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 09:50:13AM +0200, Ingo Molnar wrote:
> Have you looked at the output Peter's patch produces? It prints out 
> precise symbols:
> 
>  dcache_lock: 3000 0 [618] [<ffffffff8033badd>] _atomic_dec_and_lock+0x39/0x58
> 
> which can easily be turned into line numbers using debuginfo packages or 
> using gdb. (But normally one only needs the symbol name, and we 
> certainly do not want to burden the kernel source with tracking 
> __FILE__/__LINE__ metadata, if the same is already available via 
> CONFIG_DEBUG_INFO.)
> 
> anything else?

If his hashing scheme can produce precise locations of where locks are
initialized both by a initializer function or a statically allocated
object then my code is baroque and you should use Peter's code.

I write lockstat without the knowledge that lockdep was replicating the
same work and I audited 1600 something lock points in the kernel to
convert the usage of C99 style initializers to something more regular.

I also did this without consideration of things like debuginfo since
I don't use those things.

> > [...] My stuff is potentially more extensible since I have other ideas 
> > for it that really are outside of the lockdep logic currently. [...]
> 
> what do you mean, specifically?

Better if I show you the patches in the future instead of saying now.

> i really need specifics. Currently i have the choice between your stuff:
> 
>    17 files changed, 1425 insertions(+), 80 deletions(-)
> 
> and Peter's patch:
> 
>     6 files changed,  266 insertions(+), 18 deletions(-)
> 
> and Peter's patch (if it works out fine in testing - and it seemed fine 
> so far on my testbox), is smaller, more maintainable, better integrated 
> and thus the clear candidate for merging into -rt and merging upstream 
> as well. It's far cleaner than i hoped this whole lock-stats thing could 
> be done based on lockdep, so i'm pretty happy with Peter's current patch 
> already.

If it meets your criteria and what you mentioned about is completely
accurate, then use it instead of mine. I'll just finish up what I have
done with reader tracking in my lockstat and migrate my -rt specific
goodies to his infrastructure.

bill

