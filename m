Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZKDBy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZKDBy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZKDByz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:54:55 -0500
Received: from mga06.intel.com ([134.134.136.21]:28686 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbZKDByz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:54:55 -0500
X-ExtLoop1: 1
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: alex.shi@intel.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20091103174531.GA14747@elte.hu>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>  <20091103174531.GA14747@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2009 09:55:45 +0800
Message-Id: <1257299745.16282.49.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 18:45 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > On Tue, 2009-11-03 at 11:47 +0800, Alex Shi wrote:
> > > We found the UDP-U 1k/4k stream of netperf benchmark have some
> > > performance regression from 10% to 20% on our Tulsa and some NHM
> > > machines. 
> > ﻿ perf events shows function find_busiest_group consumes about 4.5% cpu 
> > time with the patch while it only consumes 0.5% cpu time without the 
> > patch.
> > 
> > The communication between netperf client and netserver is very fast. 
> > When netserver receives a message and there is no new message 
> > available, it goes to sleep and scheduler calls idle_balance => 
> > load_balance_newidle. load_balance_newidle spends too much time and a 
> > new message arrives quickly before load_balance_newidle ends.
> > 
> > As the comments in the patch say hackbench benefits from it, I tested 
> > hackbench on Nehalem and core2 machines. hackbench does benefit from 
> > it, about 6% on nehalem machines, but doesn't benefit on core2 
> > machines.
> 
> Can you confirm that -tip:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> has it fixed (or at least improved)?
The latest tips improves netperf loopback result, but doesn't fix it
thoroughly. For example, on a Nehalem machine, netperf UDP-U-1k has
about 25% regression, but with the tips kernel, the regression becomes
less than 10%.

yanmin


