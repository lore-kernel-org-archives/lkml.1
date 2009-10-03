Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZJCTMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZJCTMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 15:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZJCTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 15:12:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:43678 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756821AbZJCTMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 15:12:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/+mpxZ4nj+pplDOM8w2fSI3hnEcWYJdlPqPH/VRt
	VXxBREOK0A4Y+q
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
 controller V10)
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <1254596864.7153.9.camel@marge.simson.net>
References: <1254549378.8299.21.camel@marge.simson.net>
	 <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com>
	 <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com>
	 <1254578553.7499.5.camel@marge.simson.net>
	 <20091003142840.GE31616@kernel.dk>
	 <1254581496.8293.8.camel@marge.simson.net>
	 <20091003151445.GF31616@kernel.dk>
	 <1254585420.7539.2.camel@marge.simson.net>
	 <20091003173532.GG31616@kernel.dk>
	 <1254596864.7153.9.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 21:11:14 +0200
Message-Id: <1254597074.7153.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 21:07 +0200, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 19:35 +0200, Jens Axboe wrote:

> > So that's pure goodness, at least.
> 
> Yeah, but it's a double edged sword, _maybe_ cut too far in the other
> direction.  (impression)
> 
> > > perf stat testo.sh                               Avg
> > > 108.12   106.33    106.34    97.00    106.52   104.8  1.000 fairness=0 overload_delay=0
> > >  93.98   102.44     94.47    97.70     98.90    97.4   .929 fairness=0 overload_delay=1
> > >  90.87    95.40     95.79    93.09     94.25    93.8   .895 fairness=1 overload_delay=0
> > >  89.93    90.57     89.13    93.43     93.72    91.3   .871 fairness=1 overload_delay=1
> > >  89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync
> > >  92.61    94.60     92.35    93.17     94.05    93.3   .890 block-for-linus
> > 
> > Doesn't look too bad, all things considered. Apart from "stock" cfq,
> > it's consistent. And being consistent is a Good Thing. Performance wise,
> > it's losing out to "stock" but looks pretty competetive otherwise.
> 
> No, not bad at all, still a large win over stock.
> 
> > So far that looks like a winner. The dictator wanted good latency, he's
> > getting good latency. I'll continue working on this on monday, while I'm
> > waiting for delivery of the Trabant.
> 
> I'm unsure feel wise.  Disk is sounding too seeky, which worries me.

But, this is a _huge_ improvement of the dd vs reader thing regardless
of any further tweaking that may or may not prove necessary.  That ages
old corner case seems to be defeated.

	-Mike

