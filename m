Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZJBQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZJBQMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZJBQMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:12:37 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:8494 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZJBQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:12:35 -0400
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 12:12:34 EDT
Message-ID: <4AC623C4.5050003@hp.com>
Date: Fri, 02 Oct 2009 12:01:08 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> I really think we should do latency first, and throughput second.

Agree.

> It's _easy_ to get throughput. The people who care just about throughput 
> can always just disable all the work we do for latency.

But in my experience it is not that simple...

The argument latency vs throughput or desktop vs server is wrong.

I/O can never keep up with the ability of CPUs to dirty data.

On desktops and servers (really many-user-desktops) we want
minimum latency but the enemy is dirty VM.  If we ignore the
need for throughput to flush dirty pages, VM gets angry and
forced VM page cleaning I/O is bad I/O.

We want min latency with low dirty page percent but need to
switch to max write throughput at some high dirty page percent.

We can not prevent the cliff we fall off where the system
chokes because the dirty page load is too high, but if we
only worry about latency, we bring that choke point cliff in
so it happens with a lower load.  A 10% lower overload point
might be fine to get 100% better latency, but would desktop
users accept a 50% lower overload point where running one
more application makes the system appear hung?

Even desktop users commonly measure "how much work can I do
before the system becomes unresponsive".

jim
