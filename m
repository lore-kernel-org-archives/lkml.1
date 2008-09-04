Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYIDPqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYIDPqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYIDPq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:46:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYIDPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:46:26 -0400
Date: Thu, 4 Sep 2008 08:45:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <20080904153620.GC7120@elte.hu>
Message-ID: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> i've added them to tip/x86/tsc and merged it into tip/master - if 
> there's test success we can merge it into x86/urgent as well and push it 
> into v2.6.27. Any objections to that merge route?

I don't think it's quite that urgent, and wonder what the downside is of 
just changing the timeout to 10ms. On 32-bit x86, it was 30ms (I think) 
before the merge, so it sounds like 50ms was a bit excessive even before 
the whole "loop five times"/

So _short_ term, I'd really prefer (a) looping just three times and (b) 
looping with a smaller timeout.

Long-term, I actually think even 10ms is actually a total waste. I'll post 
my trial "quick calibration" code that is more likely to fail under 
virtualization or SMM (or, indeed, perhaps even on things like TMTA CPU's 
that can have longer latencies due to translation), but that is really 
fast and knows very intimately when it succeeds. I just need to do 
slightly more testing.

				Linus
