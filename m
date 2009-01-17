Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbZAQJjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbZAQJjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 04:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZAQJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 04:38:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58714 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbZAQJiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 04:38:52 -0500
Date: Sat, 17 Jan 2009 10:53:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net, maynardj@us.ibm.com
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20090117095339.GD1475@one.firstfloor.org>
References: <20081214212829.GA9435@elte.hu> <18758.18810.350923.806445@cargo.ozlabs.ibm.com> <1229437341.7025.11.camel@twins> <18760.13407.568536.198724@cargo.ozlabs.ibm.com> <87ljuf1s75.fsf@basil.nowhere.org> <4970CB6F.9000301@linux.vnet.ibm.com> <18801.13239.198051.944029@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18801.13239.198051.944029@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 12:26:15PM +1100, Paul Mackerras wrote:
> Corey Ashford writes:
> 
> > Over time, it seems clear that we will see multi-core processor designs 
> > with increasingly large uncore/nest facilities, so this could become 
> > more and more of an issue.
> 
> Those nest events still get counted on counters that are in the CPU
> core, right? 

Nope, Nehalem uncore counters are separate per socket. The uncore
has its own counters.

You can program them to interrupt some fixed CPU thread (but 
it's not necessarily the thread who caused the event) or all CPU threads
on the socket.

I found these semantics quite hard to fit into oprofile too because
it also has too many per cpu events assumptions.

> So that sounds like they can be counted by one or more
> per-cpu perf_counter instances.  That means that you're measuring them
> across all processes.  Does it make any sense to try to attribute
> those events to individual processes?  How would one do that?

You can't (except by forcing only a single thread to run on 
the socket). The hardware doesn't know otherwise.

perfmon3 has a concept of counters which are system wide.
While that's also not a 100% match on a multi socket system
it's better than assigning it to some random CPU.

> 
> Clearly, something has to know enough about the system topology to
> know how many counters are needed and which (virtual) cpus they should

Hmm you want to create new virtual cpus for this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
