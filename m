Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZJBSaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZJBSaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZJBSaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:30:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:49525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755542AbZJBSaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:30:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18aFgUXEfYaol+oaSWyszDA2HBcg1wlGg0oLguY2Z
	t7OyceC6V/N46S
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
In-Reply-To: <20091002180857.GM31616@kernel.dk>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091002180857.GM31616@kernel.dk>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 20:29:57 +0200
Message-Id: <1254508197.8667.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 20:08 +0200, Jens Axboe wrote:
> On Thu, Oct 01 2009, Mike Galbraith wrote:
> >  	max_dispatch = cfqd->cfq_quantum;
> >  	if (cfq_class_idle(cfqq))
> >  		max_dispatch = 1;
> >  
> > +	if (cfqd->busy_queues > 1)
> > +		cfqd->od_stamp = jiffies;
> > +
> 
> ->busy_queues > 1 just means that they have requests ready for dispatch,
> not that they are dispatched.

But we're not alone, somebody else is using disk.  I'm trying to make
sure we don't have someone _about_ to come back.. like a reader, so when
there's another player, stamp to give him some time to wake up/submit
before putting the pedal to the metal.

	-Mike

