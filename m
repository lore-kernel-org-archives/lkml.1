Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZERPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZERPty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZERPtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:49:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbZERPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:49:46 -0400
Date: Mon, 18 May 2009 08:48:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <20090518142301.GA22765@elte.hu>
Message-ID: <alpine.LFD.2.01.0905180840420.3301@localhost.localdomain>
References: <20090518142301.GA22765@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> Thomas Gleixner (1):
>       futex: futex mapping needs to be writable

I do not believe this is right.

Just a few lines later, we have:

         * NOTE: When userspace waits on a MAP_SHARED mapping, even if
         * it's a read-only handle, it's expected that futexes attach to   
         * the object not the particular process.

note how we are _supposed_ to be able to wait for something that is 
read-only. As such, asking for a writable page is bogus.

I'm not going to pull this. I can well imagine that there was a real bug, 
but this is _not_ the real fix.

The commentary is also TOTAL CRAP as far as I can tell. It starts out 
with:

    commit 734b05b10e51d4ba38c8fc3ee02e846aab09eedf (futex: use
    fast_gup()) calls get_user_pages_fast() with the write argument set to
    0. This went unnoticed [...]

and that is pure and utter SHIT. The fact is, the write argument was 
ALWAYS zero, and commit 734b05b10e51d4ba38c8fc3ee02e846aab09eedf has 
nothing to do with anything what-so-ever, and nothing went unnoticed 
anywhere.

The real bug was apparently just commit e4dc5b7a3 ("clean up").

I also have to object to the "Impact" line of that commit. That line is 
nonsensical and stupid. I hate to bring up this discussion again, but 
dammit, if those Impact lines are crap, then they are crap and should not 
be there! 

The fact that they _look_ nicer and do not break up the story any more 
doesn't change that fact. If you cannot write sane and meaningful impact 
lines, then f*ck me with a spoon - JUST DON'T DO THEM!

I'm upset. Quite frankly, there are just _so_ many things wrong with that 
commit that I get angry when it is sent this late in the game. 

		Linus
