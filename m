Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZJCNRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZJCNRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZJCNRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:17:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43538 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbZJCNRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:17:13 -0400
Date: Sat, 3 Oct 2009 15:17:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
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
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091003131716.GZ31616@kernel.dk>
References: <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <1254507215.8667.7.camel@marge.simson.net> <20091002181903.GN31616@kernel.dk> <1254548931.8299.18.camel@marge.simson.net> <1254549378.8299.21.camel@marge.simson.net> <20091003072401.GV31616@kernel.dk> <1254560434.17052.14.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254560434.17052.14.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:
> 
> > After shutting down the computer yesterday, I was thinking a bit about
> > this issue and how to solve it without incurring too much delay. If we
> > add a stricter control of the depth, that may help. So instead of
> > allowing up to max_quantum (or larger) depths, only allow gradual build
> > up of that the farther we get away from a dispatch from the sync IO
> > queues. For example, when switching to an async or seeky sync queue,
> > initially allow just 1 in flight. For the next round, if there still
> > hasn't been sync activity, allow 2, then 4, etc. If we see sync IO queue
> > again, immediately drop to 1.
> > 
> > It could tie in with (or partly replace) the overload feature. The key
> > to good latency and decent throughput is knowing when to allow queue
> > build up and when not to.
> 
> Hm.  Starting at 1 sounds a bit thin (like IDLE), multiple iterations to
> build/unleash any sizable IO, but that's just my gut talking.

Not sure, will need some testing of course. But it'll build up quickly.

-- 
Jens Axboe

