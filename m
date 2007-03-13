Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbXCMKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbXCMKbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXCMKbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:31:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXCMKbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:31:38 -0400
Date: Tue, 13 Mar 2007 11:31:34 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070313103134.GF8992@v2.random>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F67796.4040508@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:06:14PM +1100, Nick Piggin wrote:
> Well ignoring the HT issue, I was seeing lots of idle time simply
> because userspace could not keep up enough load to the scheduler.
> There simply were fewer runnable tasks than CPU cores.

When you said idle I thought idle and not waiting for I/O. Waiting for
I/O would be hardly a kernel issue ;). If they're not waiting for I/O
and they're not scheduling in userland with nanosleep/pause, the cpu
shouldn't go idle. Even if they're calling sched_yield in a loop the
cpu should account for zero idle time as far as I can tell.
