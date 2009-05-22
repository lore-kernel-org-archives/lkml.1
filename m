Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZEVKIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZEVKIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbZEVKIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:08:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39523 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbZEVKIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:08:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18966.31089.52074.614650@cargo.ozlabs.ibm.com>
Date: Fri, 22 May 2009 20:07:45 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1242985332.26820.630.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1242984129.26820.627.camel@twins>
	<1242985332.26820.630.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ah, should I read this as 'n' lmbench instances on a single cpu? So that
> we get multiple inheritance sets mixed and have to switch between them?

No, it's one lat_ctx instance, which creates N processes connected in
a ring with pipes, and passes a token around some number of times and
measures the overall time to do that.  It subtracts off the time it
takes to do all the pipe reads and writes in a single process to get
an estimate of how much the context switches are costing.

Paul.
