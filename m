Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYEYNor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYEYNor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYEYNoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:44:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYEYNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:44:37 -0400
Date: Sun, 25 May 2008 09:44:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH -v2] x86: enable preemption in delay
In-Reply-To: <Pine.LNX.4.58.0805250931160.20625@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0805250943010.22651@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
 <Pine.LNX.4.58.0805250931160.20625@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Steven Rostedt wrote:

> +
> +		/*
> +		 * It is possible that we moved to another CPU, and
> +		 * since TSC's are per-cpu we need to calculate
> +		 * that. The delay must guarantee that we wait "at
> +		 * least" the amount of time. Being moved to another
> +		 * CPU could make the wait longer but we just need to
> +		 * make sure we waited long enough. Rebalance the
> +		 * counter for this CPU.
> +		 */
> +		if (unlikely(cpu != smp_processor_id())) {
> +			cpu = smp_processor_id();
> +			rdtscl(bclock);
> +		}
>  	}
>  	while ((now-bclock) < loops);

BAH! expect version 3. :-p

This was compiled tested.

-- Steve

>  	preempt_enable();
>
