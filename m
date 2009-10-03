Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZJCJAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZJCJAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 05:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZJCJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 05:00:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:40425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751007AbZJCJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 05:00:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dSgpwQsfdWnTN0MhJ9IhhRyXfvjNxEerpIvzP6+
	Ih4egysnalXPCC
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20091003072401.GV31616@kernel.dk>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <1254549378.8299.21.camel@marge.simson.net>
	 <20091003072401.GV31616@kernel.dk>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 11:00:34 +0200
Message-Id: <1254560434.17052.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:

> After shutting down the computer yesterday, I was thinking a bit about
> this issue and how to solve it without incurring too much delay. If we
> add a stricter control of the depth, that may help. So instead of
> allowing up to max_quantum (or larger) depths, only allow gradual build
> up of that the farther we get away from a dispatch from the sync IO
> queues. For example, when switching to an async or seeky sync queue,
> initially allow just 1 in flight. For the next round, if there still
> hasn't been sync activity, allow 2, then 4, etc. If we see sync IO queue
> again, immediately drop to 1.
> 
> It could tie in with (or partly replace) the overload feature. The key
> to good latency and decent throughput is knowing when to allow queue
> build up and when not to.

Hm.  Starting at 1 sounds a bit thin (like IDLE), multiple iterations to
build/unleash any sizable IO, but that's just my gut talking.

	-Mike

