Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZHXWnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZHXWnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZHXWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:43:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43076 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbZHXWnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:43:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.5100.328432.510132@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 08:27:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with enable_on_exec
In-Reply-To: <1251121618.7538.262.camel@twins>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	<1251121618.7538.262.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> 2. enable_on_exec only works on leaders, Paul, was that intended?

I think I thought that would be sufficient, but I guess it would be
cleaner if it also worked on non-leaders.

> 3. the scale stuff seems broken
> 
> # perf stat -e cycles -e instructions --repeat 10 true
> 
>  Performance counter stats for 'true' (10 runs):
> 
>         2612124  cycles                     ( +-   1.327% )
>         1870479  instructions             #      0.716 IPC     ( +-   0.132% )
> 
>     0.003743155  seconds time elapsed   ( +-   1.203% )
> 
> # ./test-enable_on_exec true
>              2651600 PERF_COUNT_HW_CPU_CYCLES 1111509 1111509 2651600.000000
>              1832720 PERF_COUNT_HW_INSTRUCTIONS 839395242 1111509 1384043177.264637
> 
> Paul, would a counter's time start running when its 'enabled' but part
> of a non-runnable group?

No, it shouldn't.  If it does it's a bug.

Paul.
