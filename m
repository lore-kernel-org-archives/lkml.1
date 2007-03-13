Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXCMJqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXCMJqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXCMJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:46:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965691AbXCMJqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:46:13 -0400
Date: Tue, 13 Mar 2007 10:45:59 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070313094559.GC8992@v2.random>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F63266.1080509@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 04:11:02PM +1100, Nick Piggin wrote:
> Hi Anton,
> 
> Very cool. Yeah I had come to the conclusion that it wasn't a kernel
> issue, and basically was afraid to look into userspace ;)

btw, regardless of what glibc is doing, still the cpu shouldn't go
idle IMHO. Even if we're overscheduling and trashing over the mmap_sem
with threads (no idea if other OS schedules the task away when they
find the other cpu in the mmap critical section), or if we've
overscheduling with futex locking, the cpu usage should remain 100%
system time in the worst case. The only explanation for going idle
legitimately could be on HT cpus where HT may hurt more than help but
on real multicore it shouldn't happen.
