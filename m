Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZAUFAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZAUFAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZAUE7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:59:51 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63234 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756932AbZAUE7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:59:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFABA0dklMQWt2/2dsb2JhbACBbckMhXM
Date: Tue, 20 Jan 2009 23:54:47 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ben Gamari <bgamari@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       ltt-dev@lists.casi.polymtl.ca,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC PATCH] block: Fix bio merge induced high I/O
	latency
Message-ID: <20090121045447.GA18334@Krystal>
References: <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk> <20090120232748.GA10605@Krystal> <20090121002507.GA12616@Krystal> <720e76b80901202038p1e1f929ci56e9f35c5a629c88@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <720e76b80901202038p1e1f929ci56e9f35c5a629c88@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:50:12 up 20 days,  4:48,  2 users,  load average: 0.89, 0.57,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ben Gamari (bgamari@gmail.com) wrote:
> On Tue, Jan 20, 2009 at 7:25 PM, Mathieu Desnoyers
> <mathieu.desnoyers@polymtl.ca> wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> >
> > As a side-note : I'd like to have my results confirmed by others.
> 
> Well, I think the (fixed) patch did help to some degree (I haven't
> done fio benchmarks to compare against yet). Unfortunately, the I/O
> wait time problem still remains. I have been waiting 3 minutes now for
> evolution to start with 88% I/O wait time yet no visible signs of
> progress. I've confirmed I'm using the CFQ scheduler, so that's not
> the problem.
> 

Did you also 

echo 1 > /sys/block/sd{a,b}/device/queue_depth
echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum

(replacing sd{a,b} with your actual drives) ?

It seems to have been part of the factors that helped (along with the
patch).

And hopefully you don't have a recent Seagate hard drive like me ? :-)

So you test case is :
- start a large dd with 1M block size
- time evolution

?

Mathieu

> Also, Jens, I'd just like to point out that the problem is
> reproducible across all schedulers. Does your patch seek to tackle a
> problem specific to the CFQ scheduler, leaving the I/O wait issue for
> later? Just wondering.
> 
> I'll post some benchmarks numbers once I have them. Thanks,
> 
> - Ben
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
