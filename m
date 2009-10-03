Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZJCHZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZJCHZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 03:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZJCHZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 03:25:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZJCHZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 03:25:37 -0400
Date: Sat, 3 Oct 2009 09:25:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
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
Message-ID: <20091003072540.GW31616@kernel.dk>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <1254507215.8667.7.camel@marge.simson.net> <20091002181903.GN31616@kernel.dk> <1254548931.8299.18.camel@marge.simson.net> <20091003072021.GB21407@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003072021.GB21407@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03 2009, Ingo Molnar wrote:
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> >  	unsigned int cfq_desktop;
> > +	unsigned int cfq_desktop_dispatch;
> 
> > -	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> > +	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC]) {
> > +		cfqd->desktop_dispatch_ts = jiffies;
> >  		return 0;
> > +	}
> 
> btw., i hope all those desktop_ things will be named latency_ pretty 
> soon as the consensus seems to be - the word 'desktop' feels so wrong in 
> this context.
> 
> 'desktop' is a form of use of computers and the implication of good 
> latencies goes far beyond that category of systems.

I will rename it, for now it doesn't matter (lets not get bogged down in
bike shed colors, please).

Oh and Mike, I forgot to mention this in the previous email - no more
tunables, please. We'll keep this under a single knob.

-- 
Jens Axboe

