Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbZFPWmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbZFPWmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762269AbZFPWlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:41:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761758AbZFPWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:41:46 -0400
Message-ID: <4A381E97.9010905@zytor.com>
Date: Tue, 16 Jun 2009 15:37:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com> <20090616030522.GA22162@Krystal> <20090616083343.GD16229@elte.hu> <20090616141956.GB6541@Krystal> <4A37B8CF.8090804@zytor.com> <20090616190634.GA16430@Krystal> <4A380000.5090206@zytor.com> <20090616211357.GB21305@Krystal>
In-Reply-To: <20090616211357.GB21305@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> So, in summary :
> 
> - near-zero measurable runtime cost.
> - NMI-reentrancy constraint on a very small and well-defined trap
>   handler code path.
> - simplifies life of tracer and profilers. (meaning : makes a lot of
>   _other_ kernel code much easier to write and understand)
> - removes ad-hoc corner cases management from those users.
> - provides early error detection because the nmi-reentrant code path is
>   shared by all users.
> 
> So I'll use your own argument : making this trap handler code path
> nmi-reentrant will simplify an already existing bunch of in-kernel users
> (oprofile, perf counter tool, ftrace..). Moving the burden from
> subsystems spread across the kernel tree to a single, well defined spot
> looks like a constraint that will _diminish_ overall kernel development
> cost.
> 

No, this is utter bullshit.

YOU ARE ADDING A CONSTRAINT TO ONE OF THE HOTTEST PATHS IN THE KERNEL.

Constraining future optimizations.

To support tools.

That is what I'm objecting to.

	-hpa



