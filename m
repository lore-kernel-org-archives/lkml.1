Return-Path: <linux-kernel-owner+w=401wt.eu-S935862AbZFOV7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935862AbZFOV7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZFOV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:59:37 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:42180 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbZFOV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:59:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAMdgNkpMQWQl/2dsb2JhbACBT9MXhA0F
Date: Mon, 15 Jun 2009 17:54:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615215420.GE12919@Krystal>
References: <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu> <20090615211207.GB12919@Krystal> <20090615211605.GC27100@elte.hu> <20090615213429.GD12919@Krystal> <4A36BF61.10901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A36BF61.10901@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:50:04 up 107 days, 18:16,  3 users,  load average: 0.36, 0.28,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
> > 
> > As the maintainer of the out-of-tree LTTng tracer, which hooks in the
> > page fault handler with tracepoints, and which can build almost entirely
> > as modules, I am very tempted to argue that having the nmi-code entirely
> > robust wrt in-kernel page faults would be a very-nice-to-have feature.
> > 
> 
> I doubt that is ever going to be reliable, due to reentrancy issues.
> 
> 	-hpa

Do you mean the page fault handler code is no ever going to be reliable
or the tracer code ?

I spent a great deal of effort making LTTng lockless and reentrant wrt
NMIs. It would be great if the low-level kernel exception handlers would
do the same, therefore I would not have to isolate the tracer from the
kernel as I currently do. Well, I would still continue to isolate the
tracer from the kernel, but at least I would not have to spend as much
effort controlling what exceptions and faults paths the tracer is
executing.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
