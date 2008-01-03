Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYACRpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYACRpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYACRpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:45:11 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:49002 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYACRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:45:09 -0500
Date: Thu, 3 Jan 2008 12:42:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [RFC PATCH 00/11] mcount tracing utility
In-Reply-To: <20080103172238.GD27651@Krystal>
Message-ID: <Pine.LNX.4.58.0801031233001.4661@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103172238.GD27651@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 3 Jan 2008, Mathieu Desnoyers wrote:

> Hi Steven,
>
> Great work!

Thanks!

>
> (added Tim Bird, author of KFT/KFI to the CC list)

I'm currently investigating using -finstrument-functions instead of -pg,
but if the overhead is too much, I may try to incorporate both.

>
> One interesting aspect of LTTng is that is would be very lightweight.
> You seem to use interrupt disabling with your simple tracer and do a
> _lot_ of cacheline bouncing (trace_idx[NR_CPUS] is a very good exemple).

Please note that this tracer is more of a "simple example". There's lots
of improvements that can be made. It was meant more of to show what mcount
can bring than to push the tracer itself.

I want to stress that the tracer in this patch set is a *much* simplified
version of the latency_tracer in the RT patch. I want to start out simple,
complexity can come later ;-)

>
> LTTng would write the information to a per-cpu memory buffer in binary
> format. I see that it would be especially useful in flight recorder
> mode, where we overwrite the buffers without writing them to disk : when
> a problematic condition is reached, (a kernel oops would be a good one),
> then we just stop tracing and dump the last buffers to disk. In this
> case, we would have the last function calls that led to an OOPS.

This sounds great. My hope is that we can get the mcount (or cyg_profile)
functionality in the kernel that many different users can deploy.

-- Steve

