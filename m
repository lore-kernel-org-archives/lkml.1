Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZFWI0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZFWI0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZFWI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:26:34 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49477 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZFWI0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:26:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.37301.779108.964118@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 18:26:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
In-Reply-To: <7c86c4470906230036o677e6c48j923a7431b9912372@mail.gmail.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	<20090622115017.GC24366@elte.hu>
	<19008.25905.550815.222975@drongo.ozlabs.ibm.com>
	<7c86c4470906230036o677e6c48j923a7431b9912372@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> What happens if I do:
>    fd0 = perf_counter_open(&hwc1, getpid(), -1, -1, 0);
>    fd1 = perf_counter_open(&hwc2, getpid(), -1, fd0, 0);
> 
> And then:
>    fd2 = perf_counter_open(&hwc2, getpid(), -1, fd1, 0);

That perf_counter_open call will fail with an EINVAL error because fd1
is not a group leader.

Paul.
