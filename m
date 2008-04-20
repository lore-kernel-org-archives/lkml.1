Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYDTOJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYDTOJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYDTOJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:09:39 -0400
Received: from sandeen.net ([209.173.210.139]:16053 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYDTOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:09:39 -0400
Message-ID: <480B4EA1.5070305@sandeen.net>
Date: Sun, 20 Apr 2008 09:09:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Willy Tarreau <w@1wt.eu>, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca>
In-Reply-To: <480B44C4.4060104@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Willy Tarreau wrote:
>> What would really help would be to have 8k stacks with the lower page
>> causing a fault and print a stack trace upon first access. That way,
>> the safe setting would still report us useful information without
>> putting users into trouble.
> ..
> 
> That's the best suggestion from this thread, by far!
> Can you produce a patch for 2.6.26 for this?
> Or perhaps someone else here, with the right code familiarity, could?
> 
> Some sort of CONFIG option would likely be wanted to
> either enable/disable this feature, of course.

Changing the default warning threshold is easy, it's just a #define.
Although setting it too low would spam syslogs on some setups.

When I was trying to cram stuff into 4k in the past, I had a patch which
added a sysctl to dynamically change the warning threshold, and
optionally BUG() when I hit it for crash analysis.  It was good for
debugging, at least.  If something along those lines is desired, I could
resurrect it.

-Eric
