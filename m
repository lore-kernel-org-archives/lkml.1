Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYIDVwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYIDVwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYIDVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:52:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218AbYIDVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:52:40 -0400
Date: Thu, 4 Sep 2008 14:52:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alok Kataria <akataria@vmware.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <1220564317.11753.70.camel@alok-dev1>
Message-ID: <alpine.LFD.1.10.0809041447570.3117@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>  <20080904153620.GC7120@elte.hu>  <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> 
 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>  <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
 <1220564317.11753.70.camel@alok-dev1>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Alok Kataria wrote:
> 
> The maximum count value that I see is 84.
> In one single reboot run, on an average in about 70 iterations the val
> returned from pit_expect_msb is > 50, and eventually we hit a condition
> where the value is < 50 and we bail out of the fast method.
> 
> So just to be on safer side can we be a little less generous and
> increase the threshold to somewhere around 75 from 50 ? Or is there a
> good reason not to ?

Why would you? 

The reason the single run completed successfully was apparently that no 
actual virtualization event triggered, so it actually accessed the 
hardware successfully and without any real slowdown.  As shown also by the 
fact that the actual frequency was correct at the end.

The ones that failed presumably all had interrupts that happened in the 
VM, which then immediately triggered the "uhhuh, there was a bump" thing.

IOW, the code worked correctly as designed. It's not a 
"anti-virtualization" feature per se, it's a "detect when virtualization 
screws up timing". When virtualization (or SMI etc) does _not_ screw up 
timing, it all works fine.

			Linus
