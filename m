Return-Path: <linux-kernel-owner+w=401wt.eu-S1030245AbXAaQgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245AbXAaQgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030248AbXAaQgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:36:11 -0500
Received: from amsfep20-int.chello.nl ([62.179.120.15]:43306 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030245AbXAaQgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:36:10 -0500
Subject: Re: [PATCH] atomic.h : standardizing atomic primitives
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131162539.GA31985@Krystal>
References: <11685657414033-git-send-email-mathieu.desnoyers@polymtl.ca>
	 <1170257321.9516.42.camel@twins>  <20070131162539.GA31985@Krystal>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 17:36:03 +0100
Message-Id: <1170261363.9516.50.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 11:25 -0500, Mathieu Desnoyers wrote:
> Hi Peter,
> 
> Thanks for testing Andrew's fixes.

I haven't actually taken any from him. I just started afresh.

>  I am wondering about what happened to
> the Powerpc recursive include problems Andrew experienced. Quoting him :
> 
> "OK, I fixed eight separate compile errors in this patch series and
> now powerpc is being very ugly with a twisty maze of include
> dependencies.
> 
> I'm giving up.  Someone should publish a suite of cross-compilers for us
> so stuff like this doesn't need to happen."
> 
> I see that you have removed the include <asm/atomic.h> from bitops.h and
> system.h in powerpc. If it compiles on every architectures, then it's a
> good approach.

Yeah, I fiddled around with those powerpc headers a bit until it stopped
whining. Maybe the powerpc folks ought to eyeball it a bit, but it build
a kernel image here.

> I planned to post a new patch which uses macros for cmpxchg and xchg in
> asm-generic/atomic.h instead of inline functions. It would remove the
> dependency on system.h. However, if your modifications work well on
> every architecture, my fix might not be needed. Anyone has a preferred
> solution ? I have not been able to setup my cross-compiler test bench
> yet due to some hardware issues and waited for it before I released
> further fixes, but if you want to try my macro-based fix, I could post
> it.

Whatever people want; inlines are generally preferred due to the extra
type checking.

I just needed atomic_long_cmpxchg to work so I kicked your patches about
till they compiled.

> And about the alpha build, Does the assembler errors also happen without
> this patch ?

Yes. Something fishy going on there... gcc-4.1.1 + binutils-2.17
Compiler seems to build fine, but kernel code makes it go belly up.


