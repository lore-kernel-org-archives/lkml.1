Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZJBRVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZJBRVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZJBRVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:21:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbZJBRVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:21:23 -0400
Date: Fri, 2 Oct 2009 19:20:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002172046.GA2376@elte.hu>
References: <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002171129.GG31616@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> It's not _that_ easy, it depends a lot on the access patterns. A good 
> example of that is actually the idling that we already do. Say you 
> have two applications, each starting up. If you start them both at the 
> same time and just care for the dumb low latency, then you'll do one 
> IO from each of them in turn. Latency will be good, but throughput 
> will be aweful. And this means that in 20s they are both started, 
> while with the slice idling and priority disk access that CFQ does, 
> you'd hopefully have both up and running in 2s.
> 
> So latency is good, definitely, but sometimes you have to worry about 
> the bigger picture too. Latency is more than single IOs, it's often 
> for complete operation which may involve lots of IOs. Single IO 
> latency is a benchmark thing, it's not a real life issue. And that's 
> where it becomes complex and not so black and white. Mike's test is a 
> really good example of that.

To the extent of you arguing that Mike's test is artificial (i'm not 
sure you are arguing that) - Mike certainly did not do an artificial 
test - he tested 'konsole' cache-cold startup latency, such as:

    sh -c "perf stat -- konsole -e exit" 2>&1|tee -a $LOGFILE

against a streaming dd.

That is a _very_ relevant benchmark IMHO and konsole's cache footprint 
is far from trivial. (In fact i'd argue it's one of the most important 
IO benchmarks on a desktop system - how does your desktop hold up to 
something doing streaming IO.)

	Ingo
