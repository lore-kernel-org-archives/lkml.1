Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYKKA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYKKA1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKKA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:27:00 -0500
Received: from relais.videotron.ca ([24.201.245.36]:39600 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYKKA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:26:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 10 Nov 2008 19:26:36 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
In-reply-to: <20081110152221.64948d23.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811101917450.13034@xanadu.home>
References: <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
 <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
 <20081109022549.GA18508@Krystal>
 <alpine.LFD.2.00.0811082143320.13034@xanadu.home>
 <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
 <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
 <20081109064855.GA23782@Krystal>
 <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
 <20081109162250.GB10181@Krystal>
 <alpine.LFD.2.00.0811092304300.13034@xanadu.home>
 <20081109204256.89ab7925.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811101627510.13034@xanadu.home>
 <20081110135850.0d620f3c.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811101811130.13034@xanadu.home>
 <20081110152221.64948d23.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Andrew Morton wrote:

> On Mon, 10 Nov 2008 18:15:32 -0500 (EST)
> Nicolas Pitre <nico@cam.org> wrote:
> 
> > On Mon, 10 Nov 2008, Andrew Morton wrote:
> > 
> > > This references its second argument twice, which can cause correctness
> > > or efficiency problems.
> > > 
> > > There is no reason that this had to be implemented in cpp. 
> > > Implementing it in C will fix the above problem.
> > 
> > No, it won't, for correctness and efficiency reasons.
> > 
> > And I've explained why already.
> 
> I'd be very surprised if you've really found a case where a macro is
> faster than an inlined function.  I don't think that has happened
> before.

That hasn't anything to do with "a macro is faster" at all.  It's all 
about the order used to evaluate provided arguments.  And the first one 
might be anything like a memory value, an IO operation, an expression, 
etc.  An inline function would work correctly with pointers only and 
therefore totally break apart on x86 for example.


Nicolas
