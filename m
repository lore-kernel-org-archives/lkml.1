Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZJBQXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZJBQXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZJBQXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:23:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZJBQXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:23:48 -0400
Date: Fri, 2 Oct 2009 18:22:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Vivek Goyal <vgoyal@redhat.com>,
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
Message-ID: <20091002162240.GA12546@elte.hu>
References: <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 2 Oct 2009, Jens Axboe wrote:
> > 
> > It's really not that simple, if we go and do easy latency bits, then 
> > throughput drops 30% or more.
> 
> Well, if we're talking 500-950% improvement vs 30% deprovement, I 
> think it's pretty clear, though. Even the server people do care about 
> latencies.
> 
> Often they care quite a bit, in fact.

The other thing is that latency is basically a given property in any 
system - as an app writer you have to live with it, there's not much you 
can do to improve it.

Bandwidth on the other hand is a lot more engineerable, as it tends to 
be about batching things and you can batch in user-space too. Batching 
is often easier to do than getting good latencies.

Then there's also the fact that the range of apps that care about 
bandwidth is a lot smaller than the range of apps which care about 
latencies. The default should help more apps - i.e. latencies.

	Ingo
