Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZJBPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZJBPQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZJBPQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:16:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbZJBPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:16:29 -0400
Date: Fri, 2 Oct 2009 08:14:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
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
In-Reply-To: <20091002145610.GD31616@kernel.dk>
Message-ID: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
References: <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net>
 <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Oct 2009, Jens Axboe wrote:
> 
> Mostly they care about throughput, and when they come running because
> some their favorite app/benchmark/etc is now 2% slower, I get to hear
> about it all the time. So yes, latency is not ignored, but mostly they
> yack about throughput.

The reason they yack about it is that they can measure it.

Give them the benchmark where it goes the other way, and tell them why 
they see a 2% deprovement. Give them some button they can tweak, because 
they will.

But make the default be low-latency. Because everybody cares about low 
latency, and the people who do so are _not_ the people who you give 
buttons to tweak things with.

> I agree, we can easily make CFQ be very about about latency. If you
> think that is fine, then lets just do that. Then we'll get to fix the
> server side up when the next RHEL/SLES/whatever cycle is honing in on a
> kernel, hopefully we wont have to start over when that happens.

I really think we should do latency first, and throughput second.

It's _easy_ to get throughput. The people who care just about throughput 
can always just disable all the work we do for latency. If they really 
care about just throughput, they won't want fairness either - none of that 
complex stuff.

			Linus
