Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKZRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKZRcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYKZRcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:32:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYKZRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:32:00 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 17/17] x86 trace clock
From: Andi Kleen <andi@firstfloor.org>
References: <20081126124246.800751190@polymtl.ca>
	<20081126124637.043515637@polymtl.ca>
Date: Wed, 26 Nov 2008 18:32:04 +0100
In-Reply-To: <20081126124637.043515637@polymtl.ca> (Mathieu Desnoyers's message of "Wed, 26 Nov 2008 07:43:03 -0500")
Message-ID: <878wr64cmj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> X86 trace clock. Depends on tsc_sync to detect if timestamp counters are
> synchronized on the machine.

For that tsc_sync needs to be fixed first? e.g. see thread about
it firing incorrectly on vmware some time ago.

> A "Big Fat" (TM) warning is shown on the console when the trace clock is used on
> systems without synchronized TSCs to tell the user to
>

How about Intel systems where the TSC only stops in C3 and deeper?
You don't seem to handle that case well.

On modern Intel systems that's a common case.
> +			new_tsc = last_tsc + TRACE_CLOCK_MIN_PROBE_DURATION;
> +		/*
> +		 * If cmpxchg fails with a value higher than the new_tsc, don't
> +		 * retry : the value has been incremented and the events
> +		 * happened almost at the same time.
> +		 * We must retry if cmpxchg fails with a lower value :
> +		 * it means that we are the CPU with highest frequency and
> +		 * therefore MUST update the value.

Sorry but any global TSC measurements without scaling when the TSCs
run on different frequencies just don't make sense. The results will
be always poor. You really have to scale appropimately then and also
handle the "instable period"

-Andi

-- 
ak@linux.intel.com
