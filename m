Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZBQTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZBQTlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZBQTl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:41:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53208 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZBQTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:41:28 -0500
Date: Tue, 17 Feb 2009 19:40:40 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Viktor Rosendahl <Viktor.Rosendahl@nokia.com>,
       ext Tony Lindgren <tony@atomide.com>,
       "Moiseichuk Leonid (Nokia-D/Helsinki)" <leonid.moiseichuk@nokia.com>,
       "Kallioinen Juha (Nokia-D/Helsinki)" <juha.kallioinen@nokia.com>,
       "Siamashka Siarhei (Nokia-D/Helsinki)" <siarhei.siamashka@nokia.com>,
       "Tamminen Eero (Nokia-D/Helsinki)" <eero.tamminen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] ARM fix syscall trace return value
Message-ID: <20090217194040.GA14613@flint.arm.linux.org.uk>
References: <20090217181805.GA15788@Krystal> <1234898523.14675.18.camel@viktor.research.nokia.com> <20090217193015.GB18353@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217193015.GB18353@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 02:30:15PM -0500, Mathieu Desnoyers wrote:
> I had the same result as you with the ccnt-based clock I am currently
> developing, so I went back to a more "solid" and atomic
> atomic_add_return clock. But I noticed that we still had entry/exit with
> the same timestamps, so I was really unsure about what was happening,
> because there is no trace corruption and because I have never, ever,
> seen that kind of problem on any other architecture (x86, powerpc,
> mips...). So I fixed the syscall_trace exit parameter,

Correction: you broke syscall_trace exit by corrupting the syscall number
stored in the thread_info.

> which now makes sure there is a dependency on the return value.

I've no idea what dependency you're talking about.  ARM is for the most
part a very simple architecture and doesn't really have any dependencies.
The only kind it has are those which are automatically fixed up by the
hardware (so a load followed by an immediate use causes a pipeline stall.)

So I really can't figure out what you're going on about.  On top of that
you're trying to make things do stuff in ways they weren't designed.  Your
bug report makes zero sense to me.

> But I want to find out
> why the atomic add return failed to be atomic in that particular
> condition. I suspect there is a missing memory barrier in atomic.h.

In a single CPU context, memory barriers to the same location on ARM
don't have any effect as far as program accesses are concerned.

So again we disagree.

So, how about you tell me exactly what you're doing, give me pointers to
whatever test is failing, tell me about your hardware that you're testing
on.

Until that happens, I'm disinclined to believe any of this reported "bug".

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
