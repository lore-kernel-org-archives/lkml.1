Return-Path: <linux-kernel-owner+w=401wt.eu-S934516AbZFOVJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516AbZFOVJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934537AbZFOVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:09:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbZFOVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:09:16 -0400
Message-ID: <4A36B746.4050001@zytor.com>
Date: Mon, 15 Jun 2009 14:04:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <4A36ABB5.1040109@goop.org> <alpine.LFD.2.01.0906151326170.6276@localhost.localdomain> <4A36B238.5020203@zytor.com> <20090615205911.GC24554@elte.hu>
In-Reply-To: <20090615205911.GC24554@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> hm, does this really work? Using sysret there would be quite 
> tempting. Does anyone know the rough cycle count difference between 
> IRET and SYSRET on contemporary hardware?
> 
> Also, is SYSRET NMI-invariant? If yes then this would be a quite 
> clean all-around solution: on modern hw we'd standardize on doing 
> SYSRET from pretty much all the contexts. We'd get a nice speedup 
> and also the NMI nested pagefaults fix.
> 
> Oh, compat mode. Doesnt SYSRET on Intel CPUs have the problem of not 
> being able to switch back to 32-bit user-space?
> 

Not sure.  SYSRET/SYSEXIT are *not* general return to userspace
solutions in either case; any kind of complex modes and they can't.

And they are, of course, only applicable for returning to userspace.  As
such, I don't understand the "NMI invariant" comment.

	-hpa

