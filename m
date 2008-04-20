Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYDTOVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYDTOVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYDTOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:21:46 -0400
Received: from 1wt.eu ([62.212.114.60]:3247 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYDTOVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:21:46 -0400
Date: Sun, 20 Apr 2008 16:20:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Lord <lkml@rtr.ca>, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420142056.GC26536@1wt.eu>
References: <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <480B4EA1.5070305@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480B4EA1.5070305@sandeen.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 09:09:37AM -0500, Eric Sandeen wrote:
> Mark Lord wrote:
> > Willy Tarreau wrote:
> >> What would really help would be to have 8k stacks with the lower page
> >> causing a fault and print a stack trace upon first access. That way,
> >> the safe setting would still report us useful information without
> >> putting users into trouble.
> > ..
> > 
> > That's the best suggestion from this thread, by far!
> > Can you produce a patch for 2.6.26 for this?
> > Or perhaps someone else here, with the right code familiarity, could?
> > 
> > Some sort of CONFIG option would likely be wanted to
> > either enable/disable this feature, of course.
> 
> Changing the default warning threshold is easy, it's just a #define.

I thought it was checked only at a few places (eg: during irqs). If so,
maybe it can miss some call chains ?

> Although setting it too low would spam syslogs on some setups.

we should set it slightly below the 4k limit if we want users to switch
to 4k.

> When I was trying to cram stuff into 4k in the past, I had a patch which
> added a sysctl to dynamically change the warning threshold, and
> optionally BUG() when I hit it for crash analysis.  It was good for
> debugging, at least.  If something along those lines is desired, I could
> resurrect it.

While it's good for debugging, having users tweak the limit to eliminate
the warning is the opposite of what we're looking for. We just want to
have them report the warning without their service being disrupted.

Willy

