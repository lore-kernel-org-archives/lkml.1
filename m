Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYKNCoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYKNCoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYKNCnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:43:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:35384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYKNCnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:43:51 -0500
Date: Fri, 14 Nov 2008 03:43:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081114024347.GB24414@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org> <20081114015817.GC5063@wotan.suse.de> <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 06:07:45PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 14 Nov 2008, Nick Piggin wrote:
> > 
> > True, but is it any better to jam them all into a 300 line function
> > with gotos?
> 
> That wasn't what I was saying.
> 
> Theere are two "good" cases:
> 
>  - don't mess with things.
> 
>    This is good. Stability is good.
> 
>  - Clearly improve things. 
> 
>    This is great.
> 
> And I'll happily do either of the above.
> 
> Your patch had some improvement, but it had some clear not-so-improved 
> parts. That makes it INFERIOR to just leaving things well alone.
> 
> The thing is, I'm not very much interested in just a micro-optimization 
> that seems to be all about just gcc code generation. Long-term, that's 
> just bad.
> 
> But if it's a clear and undeniable _cleanup_, then long-term, it's 
> actually a win. If it also happens to fix some gcc stack allocation issues 
> etc, then that is just gravy.
> 
> See my point? Cleanup is good. But it had better _be_ a cleanup. Random 
> micro-optimization is not so good, especially not if it them makes the 
> code do things that good code simply shouldn't be doing.

It's not a cleanup, it's an optimisation. I just didn't happen to think
it particularly makes the code *less* clean, unlike you. But I'd *never*
try to merge pointless churn like this as a cleanup because I didn't
think the old code was too bad either.

No, it's purely an optimisation. And it is using knowlege of how gcc
generates code to some extent. But adding branch annotations and
out of lining things isn't really something gcc will be able to
do on its own (it could _guess_, or use PGO, and do better register
allocation, I guess).

Anyway, it saves 300 bytes of stack footprint and seems to save a
couple of lines of icache footprint by packing the fastpaths better.

I don't exactly know what you mean by random micro-optimization. It is
what it is. I like counting cachelines and branches and I thought you
did as well.


