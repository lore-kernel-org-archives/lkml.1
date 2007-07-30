Return-Path: <linux-kernel-owner+w=401wt.eu-S968716AbXG3VZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968716AbXG3VZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968634AbXG3VZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:25:01 -0400
Received: from ns1.suse.de ([195.135.220.2]:37558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968625AbXG3VZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:25:00 -0400
Date: Mon, 30 Jul 2007 23:24:57 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Chris Snook <csnook@redhat.com>
Cc: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: pluggable scheduler thread (was Re: Volanomark slows by 80%	under CFS)
Message-ID: <20070730212457.GJ7503@v2.random>
References: <1185573687.19777.44.camel@localhost.localdomain> <46AA8E57.8010105@redhat.com> <20070728005920.GA31622@v2.random> <46AABB5B.3030702@redhat.com> <20070728050141.GC31622@v2.random> <46AAE760.9030602@redhat.com> <1185821379.19777.58.camel@localhost.localdomain> <46AE5322.9030605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE5322.9030605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 05:07:46PM -0400, Chris Snook wrote:
> [..]  It's spending a lot less time in %sys despite the 
> higher context switches, [..]

The workload takes 40% more so you've to add up that additional 40%
too into your math. "A lot less time" sounds an overstatement to
me. Also you've to take into account cache effects in executing the
scheduler so much etc...

> [..] and there are far fewer tasks waiting for CPU 
> time. The real problem seems to be that volanomark is optimized for a 

It looks weird that there are a lot less tasks in R state. Could you
press SYSRQ+T to see where those hundred tasks are sleeping in the CFS
run?

> That's not to say that we can't improve volanomark performance under CFS, 
> but simply that CFS isn't so fundamentally flawed that this is impossible.

Given the increase of context switches, it means not all the ctx
switches are "userland mandated", so the first thing to try here is to
increase the granularity with the new tunable sysctl. Increasing the
granularity has to reduce the context switch rate, and in turn it will
reduce the slowdown to less than 40%.

There's nothing necessarily flawed in CFS even if it's slower than
O(1) in this load no matter how you tune it. The higher context switch
rate to retain complete fariness is a feature, but fariness vs global
performance is generally a tradeoff.
