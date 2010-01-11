Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289Ab0AKMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0AKMIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850Ab0AKMIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:08:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0AKMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:08:17 -0500
Subject: Re: tbench regression with 2.6.33-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1261739467.10685.18.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 13:08:00 +0100
Message-ID: <1263211680.4244.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-25 at 19:11 +0800, Lin Ming wrote:
> Hi,
> 
> Test machine: 16 cpus (4P/2Core/HT), 8G mem
> tbench test command:
> tbench_srv &
> tbench 32
> 
> Compared with 2.6.32, tbench has ~4% regression in 2.6.33-rc1.
> 
> >From vmstat data, the context switch number also drop ~4%.
> perf top data does not show much differences.
> 
> But lockstat data shows huge difference in rq->lock, as below.
> See the attachment for the full lockstat data.
> 
> Any clue of this regression?

Nope, I thought to see the same on a dual-socket machine, but when
bisecting I ended up on a user-space perf commit, which is pretty much
impossible.

I did notice some variance in the numbers between boots, maybe it was
large enough to fool me.. (~2800 MB/s was the good one, ~2200 MB/s was
the bad one).

perf itself also didn't really provide clue, perf record -ag on the
workload didn't really show anything scheduler related. vmstat 1 did
show a proportional drop in context switch rate between the kernels
though.. most odd.



