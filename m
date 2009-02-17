Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZBQUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZBQUNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZBQUN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:13:28 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:57973 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZBQUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:13:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAKekmklMQWt2/2dsb2JhbACBbtILhBMG
Date: Tue, 17 Feb 2009 15:08:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King <rmk+lkml@arm.linux.org.uk>
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
Message-ID: <20090217200816.GD18353@Krystal>
References: <20090217181805.GA15788@Krystal> <1234898523.14675.18.camel@viktor.research.nokia.com> <20090217193015.GB18353@Krystal> <20090217194040.GA14613@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090217194040.GA14613@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:05:49 up 47 days, 20:03,  4 users,  load average: 0.47, 0.42,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Tue, Feb 17, 2009 at 02:30:15PM -0500, Mathieu Desnoyers wrote:
> > I had the same result as you with the ccnt-based clock I am currently
> > developing, so I went back to a more "solid" and atomic
> > atomic_add_return clock. But I noticed that we still had entry/exit with
> > the same timestamps, so I was really unsure about what was happening,
> > because there is no trace corruption and because I have never, ever,
> > seen that kind of problem on any other architecture (x86, powerpc,
> > mips...). So I fixed the syscall_trace exit parameter,
> 
> Correction: you broke syscall_trace exit by corrupting the syscall number
> stored in the thread_info.
> 

Having a second look, yes, you are right. It's the instrumentation that
has been sent to me which was wrongly expecting scno to contain the
return value. So my patch is incorrect.

> > which now makes sure there is a dependency on the return value.
> 
> I've no idea what dependency you're talking about.  ARM is for the most
> part a very simple architecture and doesn't really have any dependencies.
> The only kind it has are those which are automatically fixed up by the
> hardware (so a load followed by an immediate use causes a pipeline stall.)
> 
> So I really can't figure out what you're going on about.  On top of that
> you're trying to make things do stuff in ways they weren't designed.  Your
> bug report makes zero sense to me.
> 
> > But I want to find out
> > why the atomic add return failed to be atomic in that particular
> > condition. I suspect there is a missing memory barrier in atomic.h.
> 
> In a single CPU context, memory barriers to the same location on ARM
> don't have any effect as far as program accesses are concerned.
> 
> So again we disagree.
> 
> So, how about you tell me exactly what you're doing, give me pointers to
> whatever test is failing, tell me about your hardware that you're testing
> on.
> 
> Until that happens, I'm disinclined to believe any of this reported "bug".
> 

Looking at my trace-clock-32-to-64 code tells me I might have problems
specific to little endian machines. I'll review that.

Thanks for the answer,

Best regards,

Mathieu

> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
