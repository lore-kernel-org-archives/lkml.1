Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYLOML6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYLOML6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYLOMLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:11:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYLOMLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:11:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18758.18810.350923.806445@cargo.ozlabs.ibm.com>
Date: Mon, 15 Dec 2008 23:11:38 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <20081214212829.GA9435@elte.hu>
References: <20081214212829.GA9435@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> We are pleased to announce the v4 release of our performance counters 
> subsystem implementation.

Looking at the code, I am wondering what you are planning to do to
support machines that have constraints on what sets of events can be
counted simultaneously.  Currently you have the core code calling
counter->hw_ops->hw_perf_counter_enable which can't return an error.
The core expects it to be able to add any counter regardless of what
event it's counting, subject only to a maximum number of counters.
I assume you're going to change that.

I think the core should put together a list of counters and counter
groups that it would like to have on the PMU simultaneously and then
make one call to the arch layer to ask if that is possible.  That
could either return success or failure.  If it returns failure then
the core needs to ask for something less, or something different.  I'm
not sure how the core should choose what to ask for instead, though.

Paul.
