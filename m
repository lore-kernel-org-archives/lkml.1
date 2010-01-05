Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730Ab0AEPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0AEPQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568Ab0AEPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:16:52 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33110 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0AEPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:16:49 -0500
Date: Tue, 5 Jan 2010 09:14:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001050907100.1074@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, KAMEZAWA Hiroyuki wrote:

> I'd like to hear use cases of really heavy users, too. Christoph ?

A typical use case is a highly parallel memory intensive process
(simulations f.e.). Those are configured with the number of hardware
threads supported in mind to max out the performance of the underlying
hardware. On startup they start N threads and then each thread begins
initializing its memory (to get proper locality it has to be done this
way, you also want concurrency during this expensive operation).

The larger the number of threads the more contention on the
cachelines containing mmap_sem and the other cacheline containing the rss
counters. In extreme cases we had to wait 30mins to an hour in order for
the cacheline bouncing to complete (startup of a big HPC app on
IA64 with 1k threads).
