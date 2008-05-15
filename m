Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYEOIl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYEOIl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYEOIls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:41:48 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56858 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874AbYEOIlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:41:47 -0400
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <20080515082033.GA14823@linux.vnet.ibm.com>
References: <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
	 <1210583090.7402.4.camel@marge.simson.net>
	 <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
	 <20080514134414.GA12693@linux.vnet.ibm.com>
	 <1210777967.10126.17.camel@twins>
	 <20080515082033.GA14823@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 15 May 2008 10:41:38 +0200
Message-Id: <1210840898.21616.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 13:50 +0530, Srivatsa Vaddagiri wrote:
> On Wed, May 14, 2008 at 05:12:47PM +0200, Peter Zijlstra wrote:
> > A few other things I found that make a significant difference:
> 
> One more observation: access to aggregate()->rq_weight etc arent
> correctly synchronized i.e while a cpu is doing a aggregate_walk_tree()
> in a domain, and thus possibly modifying rq_weight, load etc, other cpus could 
> be concurrently accessing the same data. As a result, its possible to
> see inconsistent rq_weight, load, task_weight combination?

Yes - and that should not be too big an issue as long as we can deal
with it.

Any number we'll put to it will be based on a snapshot of the state so
we're wrong no matter what we do. The trick is trying to keep sane.

My current stack on top of sched-devel:

http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/

I've found that:
http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/sched-agg-update-move_tasks.patch

was sufficient to deal with all the anomalities I've found so far.

