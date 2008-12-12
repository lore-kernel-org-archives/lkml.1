Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYLLNie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYLLNie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbYLLNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:38:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:52252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbYLLNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:38:25 -0500
Subject: Re: CFS scheduler OLTP perforamnce
From: Peter Zijlstra <peterz@infradead.org>
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
In-Reply-To: <1229083933.12883.179.camel@twins>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
	 <1229083933.12883.179.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2008 14:38:20 +0100
Message-Id: <1229089100.25485.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 13:12 +0100, Peter Zijlstra wrote:
> On Thu, 2008-12-11 at 16:25 -0700, Ma, Chinang wrote:
> > We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In
> > this workload once a database foreground process commit a transaction
> > it will signal the log writer process to write to the log file.
> > Foreground processes will wait until log writer finish writing and
> > wake them up. With hundreds of foreground process running in the
> > system, it is important that the log writer get to run as soon as data
> > is available. 
> > 
> > Here are the experiments we have done with 2.6.28-rc7.
> > 1. Increase log writer priority "renice -20 <log writer pid>" while
> > keeping all other processes running in default CFS priority. We get a
> > baseline performance with log latency (scheduling + i/o) at 7 ms.
> 
> Is this better or the same than nice-0 ?
> 
> > 2. To reduce log latency, we set log writer to SCHED_RR with higher
> > priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost
> > in performance with log latency reduced to 6.4 ms.

BTW, 6.4ms schedule latency sounds insanely long for a RR task, are you
running a PREEMPT=n kernel or something?

How would you characterize the log tasks behaviour?

 - does it run long/short (any quantization)
 - does it sleep long/short - how does it compare to its runtime?
 - does it wake others?
   - if so, always the one who woke it, or multiple others?


