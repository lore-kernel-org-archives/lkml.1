Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZJBRZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZJBRZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbZJBRZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:25:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50715 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbZJBRZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:25:51 -0400
Date: Fri, 2 Oct 2009 19:25:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20091002172554.GJ31616@kernel.dk>
References: <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002172046.GA2376@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's not _that_ easy, it depends a lot on the access patterns. A good 
> > example of that is actually the idling that we already do. Say you 
> > have two applications, each starting up. If you start them both at the 
> > same time and just care for the dumb low latency, then you'll do one 
> > IO from each of them in turn. Latency will be good, but throughput 
> > will be aweful. And this means that in 20s they are both started, 
> > while with the slice idling and priority disk access that CFQ does, 
> > you'd hopefully have both up and running in 2s.
> > 
> > So latency is good, definitely, but sometimes you have to worry about 
> > the bigger picture too. Latency is more than single IOs, it's often 
> > for complete operation which may involve lots of IOs. Single IO 
> > latency is a benchmark thing, it's not a real life issue. And that's 
> > where it becomes complex and not so black and white. Mike's test is a 
> > really good example of that.
> 
> To the extent of you arguing that Mike's test is artificial (i'm not 
> sure you are arguing that) - Mike certainly did not do an artificial 
> test - he tested 'konsole' cache-cold startup latency, such as:

[snip]

I was saying the exact opposite, that Mike's test is a good example of a
valid test. It's not measuring single IO latencies, it's doing a
sequence of valid events and looking at the latency for those. It's
benchmarking the bigger picture, not a microbenchmark.

-- 
Jens Axboe

