Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYKGUEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYKGUEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYKGUD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:03:57 -0500
Received: from relais.videotron.ca ([24.201.245.36]:54701 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYKGUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:03:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 15:03:49 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081107092115.7c3c4a49.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811071458560.13034@xanadu.home>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org>
 <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca>
 <20081106220530.5b0e3a96.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
 <25363.1226056819@redhat.com>
 <alpine.LFD.2.00.0811070952150.13034@xanadu.home>
 <20081107075003.fa93ccf4.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811071129440.13034@xanadu.home>
 <20081107092115.7c3c4a49.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Andrew Morton wrote:

> On Fri, 07 Nov 2008 11:47:47 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:
> 
> > > btw, do you know how damned irritating and frustrating it is for a code
> > > reviewer to have his comments deliberately ignored and deleted in
> > > replies?
> > 
> > Do you know how irritating and frustrating it is when reviewers don't 
> > care reading the damn comments along with the code?
> 
> As you still seek to ignore it, I shall repeat my earlier question. 
> Please do not delete it again.
> 
>    It apparently tries to avoid races via ordering tricks, as long
>    as it is called with sufficient frequency.  But nothing guarantees
>    that it _is_ called sufficiently frequently?
> 
> Things like tickless kernels and SCHED_RR can surely cause
> sched_clock() to not be called for arbitrary periods.

On the machines this was initially written for, the critical period is 
in the order of minutes.  And if you're afraid you might lack enough 
scheduling activities for that long, you simply have to keep the 
algorithm "warm" with a simple kernel timer which only purpose is to 
ensure it is called often enough.

> Userspace cli() will definitely do this, but it is expected to break
> stuff and is not as legitiate a thing to do.

Why do you bring it on then?

> I'm just giving up on the tastefulness issue.

Taste is a pretty subjective matter.


Nicolas
