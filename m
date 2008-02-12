Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbYBLTDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbYBLTDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbYBLTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:02:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbYBLTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:02:55 -0500
Date: Tue, 12 Feb 2008 11:01:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
In-Reply-To: <20080212192227.GB6458@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802121059320.2920@woody.linux-foundation.org>
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu>
 <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <alpine.LFD.1.00.0802121001180.2920@woody.linux-foundation.org> <20080212192227.GB6458@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Andi Kleen wrote:
> 
> There tend to be timeouts (e.g. softlock/nmi watchdog at least). I think
> some of the IPIs eventually time out too.  In general losing a lot 
> of time can lead to weird side effects.

I do agree that kgdb and watchdogs aren't like to work well together. And 
I don't think you can sanely expect to not have a "disable lockup 
detection" when you start poking around with kgdb.

We also just have to expect that time will also stop while sometbody is 
messing around with kgdb.

So I don't dispute that any kernel debugger will *always* be intrusive in 
those ways. That's pretty inevitable. I just think the code itself can try 
to avoid hooking into various places all over the map.

			Linus
