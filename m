Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbXCMK5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbXCMK5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXCMK5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:57:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:54294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXCMK5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:57:51 -0400
Date: Tue, 13 Mar 2007 11:57:42 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070313105742.GG8992@v2.random>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F67F02.5020401@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:37:54PM +1100, Nick Piggin wrote:
> Well it wasn't iowait time. From Anton's analysis, I would probably
> say it was time waiting for either the glibc malloc mutex or MySQL
> heap mutex.

So it again makes little sense to me that this is idle time, unless
some userland mutex has a usleep in the slow path which would be very
wrong, in the worst case they should yield() (yield can still waste
lots of cpu if two tasks in the slow paths calls it while the holder
is not scheduled, but at least it wouldn't be idle time).

Idle time is suspicious for a kernel issue in the scheduler or some
userland inefficiency (the latter sounds more likely).
