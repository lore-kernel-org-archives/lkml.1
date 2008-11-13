Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYKMSU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYKMSU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKMSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:20:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36887 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYKMSUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:20:19 -0500
Date: Thu, 13 Nov 2008 19:29:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Message-ID: <20081113182937.GZ3810@one.firstfloor.org>
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com> <20081113171220.GX3810@one.firstfloor.org> <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com> <20081113173451.GY3810@one.firstfloor.org> <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:32:23PM -0500, Steven Rostedt wrote:
> 
> On Thu, 13 Nov 2008, Andi Kleen wrote:
> 
> > > So the answer to this is:
> > > 
> > >   i = index++;
> > >   barrier();
> > >   write to index i (not index);
> > 
> > That was my first thought when I wrote the original email,
> > but the disadvantage is that barrier() is a big hammer
> > that flushes everything and can make the code much worse.
> > That is why I suggested local_add_return() instead.
> 
> barrier() is a compiler barrier, does nothing with the caches, and is 
> quite cheap. We only need a compiler barrier because we are only 

I did not refer to CPU caches, but the compiler's register allocation
[ok if you want the registers are the "level 0 cache"]. A memory barrier
all messes it up. That is why it is better to only clobber specific
memory regions, which is what local_* does.

-Andi

-- 
ak@linux.intel.com
