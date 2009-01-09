Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZAIVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZAIVsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZAIVsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:48:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbZAIVsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:48:20 -0500
Date: Fri, 9 Jan 2009 13:46:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <20090109213442.GA20051@elte.hu>
Message-ID: <alpine.LFD.2.00.0901091342350.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
 <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Ingo Molnar wrote:
> 
> - Perhaps we could introduce a name for the first category: __must_inline? 
>   __should_inline? Not because it wouldnt mean 'always', but because it is 
>   'always inline' for another reason than the correctless __always_inline.

I think you're thinking about this the wrong way.

"inline" is a pretty damn strong hint already.

If you want a weaker one, make it _weaker_ instead of trying to use 
superlatives like "super_inline" or "must_inline" or whatever.

So I'd suggest:

 - keep "inline" as being a strong hint. In fact, I'd suggest it not be a 
   hint at all - when we say "inline", we mean it. No ambiguity 
   _anywhere_, and no need for idiotic "I really really REALLY mean it" 
   versions.

 - add a "maybe_inline" or "inline_hint" to mean that "ok, compiler, maybe 
   this is worth inlining, but I'll leave the final choice to you".

That would get rid of the whole rationale for OPTIMIZE_INLINING=y, because 
at that point, it's no longer potentially a correctness issue. At that 
point, if we let gcc optimize things, it was a per-call-site conscious 
decision.

			Linus
