Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZKCRpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZKCRpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZKCRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:45:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42119 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZKCRpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:45:35 -0500
Date: Tue, 3 Nov 2009 18:45:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: alex.shi@intel.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
Message-ID: <20091103174531.GA14747@elte.hu>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com> <1257222791.16282.46.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1257222791.16282.46.camel@ymzhang>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> On Tue, 2009-11-03 at 11:47 +0800, Alex Shi wrote:
> > We found the UDP-U 1k/4k stream of netperf benchmark have some
> > performance regression from 10% to 20% on our Tulsa and some NHM
> > machines. 
> ﻿ perf events shows function find_busiest_group consumes about 4.5% cpu 
> time with the patch while it only consumes 0.5% cpu time without the 
> patch.
> 
> The communication between netperf client and netserver is very fast. 
> When netserver receives a message and there is no new message 
> available, it goes to sleep and scheduler calls idle_balance => 
> load_balance_newidle. load_balance_newidle spends too much time and a 
> new message arrives quickly before load_balance_newidle ends.
> 
> As the comments in the patch say hackbench benefits from it, I tested 
> hackbench on Nehalem and core2 machines. hackbench does benefit from 
> it, about 6% on nehalem machines, but doesn't benefit on core2 
> machines.

Can you confirm that -tip:

  http://people.redhat.com/mingo/tip.git/README

has it fixed (or at least improved)?

	Ingo
