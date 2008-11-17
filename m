Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYKQUah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYKQUah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYKQUa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:30:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbYKQUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:30:27 -0500
Date: Mon, 17 Nov 2008 12:30:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117.121641.167690467.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811171218470.18283@nehalem.linux-foundation.org>
References: <20081117184951.GA5585@elte.hu> <20081117.113936.81699150.davem@davemloft.net> <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org> <20081117.121641.167690467.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, David Miller wrote:
> 
> It's on my workstation which is a much simpler 2 processor
> UltraSPARC-IIIi (1.5Ghz) system.

Ok. It could easily be something like a cache footprint issue. And while I 
don't know my sparc cpu's very well, I think the Ultrasparc-IIIi is super- 
scalar but does no out-of-order and speculation, no? So I could easily see 
that the indirect branches in the scheduler hurt much more, and might 
explain why the x86 profile looks so different.

One thing that non-NMI profiles also tend to show is "clumping", which in 
turn tends to rather excessively pinpoint code sequences that release the 
irq flag - just because those points show up in profiles, rather than 
being a spread-out-mush. So it's possible that Ingo's profile did show the 
scheduler more, but it was in the form of much more spread out "noise" 
rather than the single spike you saw. 

		Linus
