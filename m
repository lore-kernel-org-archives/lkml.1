Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbYBOUgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbYBOUgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYBOUgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:36:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:52378 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbYBOUgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:36:42 -0500
Message-ID: <47B5F7B3.6010607@windriver.com>
Date: Fri, 15 Feb 2008 14:36:03 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
References: <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 20:35:38.0860 (UTC) FILETIME=[5341C2C0:01C87012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [ The exception being that I think hw breakpoint support should be added
> back in - never mind that it won't work if the "native kernel" also uses
> them. Tough.
>
> If the debugger screws up the hw breakpoint state, that's a debugger
> error. I'd hope that the remote debugger *defaults* to just re-writing
> the instruction stream for that reason, but if you want to do a data
> breakpoint, you simply *have* to use the hw breakpoints for kgdb.
>
> And you just need to live with the fact that it simply won't be possible
> to do if the client wants to use hw breakpoints too. If the client
> starts using hw breakpoints - tough titties, it takes them. ]
>
> So keep the damn thing really simple, and don't try to handle every
> possible thing. We expect the debugger side to have a person with some
> flexibility on it.
>
> Linus

HW breakpoints (particularly data breakpoints) are extremely useful
and I am proposing to put them back into kgdb-light. The HW
breakpoint patch worked exactly as described. If the user space
writes into the HW breakpoint registers via ptrace, those take
priority over the kernel HW breakpoints.

We have to assume that the person debugging the kernel ultimately has
full control of the system, and will do what ever is needed to
debug/inspect the kernel how he or she chooses.

Of course at some future time if there is a generic API to use for the
kernel level HW breakpoints, kgdb can adapt like anything else.

Jason.
