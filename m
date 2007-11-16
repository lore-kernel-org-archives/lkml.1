Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbXKPCZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbXKPCZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXKPCZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:25:41 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:45429 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbXKPCZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:25:39 -0500
Date: Thu, 15 Nov 2007 21:25:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: john cooper <john.cooper@third-harmonic.com>
cc: Tim Bird <tim.bird@am.sony.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: MIPS RT debug support
In-Reply-To: <473CF8A5.9030101@third-harmonic.com>
Message-ID: <Pine.LNX.4.58.0711152121340.30058@gandalf.stny.rr.com>
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
 <473BADD4.5030400@third-harmonic.com> <473CD6E1.1060607@am.sony.com>
 <Pine.LNX.4.58.0711151956430.30058@gandalf.stny.rr.com>
 <473CF8A5.9030101@third-harmonic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Nov 2007, john cooper wrote:

>
> It isn't an issue of getting a hook into the FUNCTION_PROLOGUE
> (mcount() here) but rather of emulating the CALLER_ADDR[0123]
> defs which map onto the gcc internal __builtin_return_address().
> Doing so using the affectionately dubbed "Three Stooges Algorithm"
> called out in the MIPS ABI is both complex and nondeterministic.
>
> The entry FUNCTION_PROLOGUE hook provides a means to log the path
> traveled thus far.  __builtin_return_address() gives a way to
> snapshot a stub of the stack invocation. Together they provide
> somewhat complimentary but useful debug information.
>
> We could log the stack invocation progress in the latency
> instrumentation itself by noting a new invocation in the
> FUNCTION_PROLOGUE and unwind of the same in the currently
> unused FUNCTION_EPILOGUE hook.  So we're just shadowing the
> actual runtime stack in effect with a data structure which
> can be traversed far more easily.
>

IIRC, only CALLER_ADDR0 is actually used (I've found that the others are
mostly unreliable).  I thought that mips always has one register that
holds the return address of the function. It's been several years since
I've worked on mips (I'd love to do it again, if someone sends me a box!,
hint hint).  So the __builtin_return_address(0) should simply return that
register. Now I'm being a bit lazy, and I'm not pulling out my MIPS books,
so I could be completely wrong on this.

-- Steve

