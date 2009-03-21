Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZCUVvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZCUVvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZCUVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:51:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZCUVvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:51:23 -0400
Date: Sat, 21 Mar 2009 17:48:52 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321214852.GA5262@redhat.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321154501.GA2707@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Mar 21, 2009 at 04:45:01PM +0100, Ingo Molnar wrote:
> [...]
> To me personally there are two big direct usability issues with 
> SystemTap:
> 
>  1) It relies on DEBUG_INFO for any reasonable level of utility.
>     Yes, it will limp along otherwise as well, but most of the
>     actual novel capabilities depend on debuginfo. Which is an
>     acceptable constraint for enterprise usage where kernels are
>     switched every few months and having a debuginfo package is not
>     a big issue. Not acceptable for upstream kernel development. 

In my own limited kernel-building experience, I find the debuginfo
data conveniently and instantly available after every "make".  Can you
elaborate how is it harder for you to incidentally make it than for
someone to download it?


>     It also puts way too trust into the compiler generating 1GB+ of
>     debuginfo correctly. I want to be able to rely on tools all the
>     time and thus i want tools to have some really simple and
>     predictable foundations.

Well, the data has to come from *somewhere*.  We know several
shortcomings (and have staff working on gcc debuginfo improvements),
but there is little alternative.  If not from the compiler, where are
you going to get detailed type/structure layouts?  Stack slot to
variable mappings?  Statement-level PC addresses?  Unwind data?


>  2) It's not upstream and folks using it seem to insist on not 
>     having it upstream ;-) This 'distance' to upstream seems to have 
>     grown during the past few years - instead of shrinking. [...]

Considering our upstream-bound assistance with foundation technologies
like markers, tracepoints, kprobes, utrace, and several other bits,
this does not seem entirely fair.


> If these fundamental problems are addressed then i'd even argue for
> the totality of SystemTap to be aimed upstreamed (including the
> scripting language, etc.), [...]

If consensus on this were plausible, we could seriously discuss it.

But I don't buy the package-deal that utrace must not attempt merging
on its own merits, just because it makes systemtap (as it is today)
useful to more people.


- FChE
