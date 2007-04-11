Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXDKKBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXDKKBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXDKKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:01:50 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:37651 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXDKKBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:01:50 -0400
Date: Wed, 11 Apr 2007 11:35:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070411113525.baf8deb0.dada1@cosmosbay.com>
In-Reply-To: <461CA90E.3080306@yahoo.com.au>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
	<461764A6.3080703@yahoo.com.au>
	<20070407120051.9ed0e69a.dada1@cosmosbay.com>
	<461C8CD1.3080707@yahoo.com.au>
	<20070411101458.114125ee.dada1@cosmosbay.com>
	<461CA90E.3080306@yahoo.com.au>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 19:23:26 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:


> But... that isn't there in mainline. Why is it in -mm? At any rate, that makes
> it a no brainer to change.

Seems to be related to lguest. Ask Rusty :)

> 
> > 
> > As this external thing certainly is not doing the check itself, to be on the safe side we should enforce it in get_futex_key(). I agree with you : If we want to maximize performance, we could say : The check *must* be done by the caller.
> 
> Well we _control_ the API, so let's make it as clean and performant as possible
> from the start.

Take a look at do_futex().
Adding checks in callers just increase code size. I tried this got only bad results.
This would speedup only the slow path (ie when some user code want to give us non aligned addrs)
A single factorized check is cleaner and not slower, since we reduce icache pressure.

