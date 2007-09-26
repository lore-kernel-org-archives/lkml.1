Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXIZKTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXIZKTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXIZKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:19:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbXIZKTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:19:05 -0400
Date: Wed, 26 Sep 2007 12:18:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926101851.GC2993@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com> <20070926093445.GA24768@elte.hu> <20070926094726.GA27006@elte.hu> <20070926100859.GJ3337@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926100859.GJ3337@deprecation.cyrius.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Michlmayr <tbm@cyrius.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2007-09-26 11:47]:
> > > this will gather a good deal of info about the workload in question. 
> > > Please send me the resulting debug file.
> > Another thing: please also do the same with the vanilla v2.6.22 kernel, 
> > and send me that file too. (so that the two cases can be compared)
> 
> I put the log files here:
> http://www.cyrius.com/tmp/2.6.22
> http://www.cyrius.com/tmp/2.6.23-rc8-sched-devel
> 
> I increased the time ipfer ran to 30 secs since your script runs for
> over 15 secs.  I got:
> 
> [  3]  0.0-30.0 sec    331 MBytes  92.6 Mbits/sec   2.6.22
> vs
> [  3]  0.0-30.0 sec    222 MBytes  62.1 Mbits/sec   2.6.23-rc8-sched-devel

thanks!

the test does almost no context switches:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0 462928   3280  37216    0    0   137    75 2306   83 13 38 47  2
 2  0      0 462928   3280  37216    0    0     0     0 8600   54  6 94  0  0
 2  0      0 462928   3280  37216    0    0     0    36 8667   55  7 93  0  0
 2  0      0 462928   3280  37216    0    0     0     0 8592   53  5 95  0  0
 2  0      0 462928   3280  37216    0    0     0     0 8638   52  7 93  0  0

(the 'cs' column shows 50-80 context switches per second.)

so there must be some other side-effect, not raw scheduling overhead or 
some other direct scheduler performance problem.

	Ingo
