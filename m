Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYBLSrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYBLSrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYBLSq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:46:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbYBLSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:46:57 -0500
Date: Tue, 12 Feb 2008 20:22:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212192227.GB6458@one.firstfloor.org>
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <alpine.LFD.1.00.0802121001180.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121001180.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:11:13AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Andi Kleen wrote:
> >
> > >  - the kgdb commands should always act on the *current* CPU only
> > >  - add one command that says "switch over to CPU #n" which just releases 
> > >    the current CPU and sends an IPI to that CPU #n (no timeouts, no 
> > >    synchronous waiting, no nothing - it's like a "continue", but with a 
> > >    "try to get the other CPU to stop"
> > 
> > The problem I see here is that the kernel tends to get badly confused
> > if one CPU just stops responding. At some point someone does an global
> > IPI and that then hangs.  You would need to hotunplug the CPU which
> > is theoretically possible, but quite intrusive.
> 
> You're thinking about this totally *wrong*.
> 
> You definitely do not want to hot-unplug or isolate anything at all. 

I agree that it wouldn't be a good idea -- i was just pointing out
consequences of your proposal.

> Just let the other CPU's hang naturally if they need to wait for IPI's 
> etc. What's the downside?

There tend to be timeouts (e.g. softlock/nmi watchdog at least). I think
some of the IPIs eventually time out too.  In general losing a lot 
of time can lead to weird side effects.

-Andi
