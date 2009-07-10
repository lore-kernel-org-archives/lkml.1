Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZGJTwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZGJTwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZGJTwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:52:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbZGJTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:52:46 -0400
Date: Fri, 10 Jul 2009 12:52:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <20090710193110.GA28281@elte.hu>
Message-ID: <alpine.LFD.2.01.0907101249060.3352@localhost.localdomain>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Ingo Molnar wrote:
> > 
> > but I really migth have done soemthing wrong there. It's a simple 
> > function, but somebody needs to double-check that I haven't made 
> > it worse.
> 
> Looks correct to me.

Note, I didn't look at how 'end' works, and it really does matter if 'end' 
is an "inclusive" or "exclusive" end pointer address. So my replacement 
overlap() function was written more as a conceptual patch - I did not 
check the exact semantics of the arguments passed in.

If 'end' is exclusive, then 'b1' should be calculated as 'a1+size-1', 
because the ranges must have the same rules. And then you should use the 
'strict inequality' operators for testing the ranges.

		Linus
