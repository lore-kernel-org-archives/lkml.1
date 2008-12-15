Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYLOWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYLOWx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYLOWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:53:50 -0500
Received: from ozlabs.org ([203.10.76.45]:50631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYLOWxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:53:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18758.54934.718129.837813@cargo.ozlabs.ibm.com>
Date: Tue, 16 Dec 2008 09:13:42 +1100
From: Paul Mackerras <paulus@samba.org>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <Pine.LNX.4.64.0812151606280.3197@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>
	<Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
	<Pine.LNX.4.64.0812151606280.3197@pianoman.cluster.toy>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver writes:

> I'm trying a more complicated benchmark and getting even stranger
> results.
> 
> This is still on the Q6600 machine
> 
> The benchmark does a loop, reading some memory.  It should have
> roughly:
>     12295 instructions
>      4096 memory loads
>      4096 branches
> 
> perfmon3 is close on all of these stats, and this is consistent
> across runs with a small variation (+/- 3 or so).
> 
> The timec program returns 0 (!) for all of the stats except
> retired instruction count!  And with certain combinations
> of counters I get 0 for all counts.  No error messages 
> are printed.
> 
> Is this expected behavior?

When you have more software counters than hardware counters, the
kernel will be time-slicing the counters, but because your program
doesn't run for very long, it's possible that only the first set will
ever get to count anything.

That doesn't seem to explain all the 0 values (since the kernel should
be able to use at least 2 hardware counters on your machine, I expect)
but it might be part of the explanation.

Paul.
