Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYKNCIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYKNCIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNCIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:08:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbYKNCH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:07:59 -0500
Date: Thu, 13 Nov 2008 18:07:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
In-Reply-To: <20081114015817.GC5063@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org> <20081114015817.GC5063@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Nov 2008, Nick Piggin wrote:
> 
> True, but is it any better to jam them all into a 300 line function
> with gotos?

That wasn't what I was saying.

Theere are two "good" cases:

 - don't mess with things.

   This is good. Stability is good.

 - Clearly improve things. 

   This is great.

And I'll happily do either of the above.

Your patch had some improvement, but it had some clear not-so-improved 
parts. That makes it INFERIOR to just leaving things well alone.

The thing is, I'm not very much interested in just a micro-optimization 
that seems to be all about just gcc code generation. Long-term, that's 
just bad.

But if it's a clear and undeniable _cleanup_, then long-term, it's 
actually a win. If it also happens to fix some gcc stack allocation issues 
etc, then that is just gravy.

See my point? Cleanup is good. But it had better _be_ a cleanup. Random 
micro-optimization is not so good, especially not if it them makes the 
code do things that good code simply shouldn't be doing.

As it is, I don't think your patch is appropriate to be merged. 

			Linus
