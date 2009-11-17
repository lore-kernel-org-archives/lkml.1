Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZKQISj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZKQISj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZKQISi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:18:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZKQISh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:18:37 -0500
Date: Tue, 17 Nov 2009 09:18:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michel Lespinasse <walken@google.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091117081817.GA7963@elte.hu>
References: <20091117074655.GA14023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117074655.GA14023@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michel Lespinasse <walken@google.com> wrote:

> Sample test results, on a sun x4600 M2, using the test program 
> included after the diff (dumb lock/unlock stress test, comparing 
> FUTEX_SET_WAIT with FUTEX_WAIT):
> 
> FUTEX_SET_WAIT test
> 1 threads: 45662 Kiter/s (2.19s user 0.00s system 2.19s wall 1.00 cores)
> 2 threads: 11834 Kiter/s (11.07s user 4.70s system 8.45s wall 1.87 cores)
> 3 threads: 9425 Kiter/s (11.10s user 14.73s system 10.61s wall 2.43 cores)
> 4 threads: 20790 Kiter/s (5.73s user 10.53s system 4.81s wall 3.38 cores)
> 5 threads: 21505 Kiter/s (5.05s user 14.02s system 4.65s wall 4.10 cores)
> 6 threads: 18904 Kiter/s (5.64s user 19.07s system 5.29s wall 4.67 cores)
> 8 threads: 17212 Kiter/s (6.10s user 28.39s system 5.81s wall 5.94 cores)
> 10 threads: 19493 Kiter/s (5.20s user 35.82s system 5.13s wall 8.00 cores)
> 12 threads: 20325 Kiter/s (4.92s user 42.52s system 4.92s wall 9.64 cores)
> 16 threads: 22026 Kiter/s (4.64s user 56.58s system 4.54s wall 13.48 cores)
> 24 threads: 23041 Kiter/s (4.33s user 84.76s system 4.34s wall 20.53 cores)
> 32 threads: 23585 Kiter/s (4.11s user 112.75s system 4.24s wall 27.56 cores)
> 64 threads: 25907 Kiter/s (3.93s user 115.99s system 3.86s wall 31.07 cores)
> 128 threads: 26455 Kiter/s (4.02s user 114.50s system 3.78s wall 31.35 cores)
> 256 threads: 26596 Kiter/s (3.93s user 114.55s system 3.76s wall 31.51 cores)
> 512 threads: 26596 Kiter/s (3.92s user 114.74s system 3.76s wall 31.56 cores)
> 1024 threads: 26525 Kiter/s (3.95s user 115.96s system 3.77s wall 31.81 cores)
> 
> FUTEX_WAIT test
> 1 threads: 46083 Kiter/s (2.17s user 0.00s system 2.17s wall 1.00 cores)
> 2 threads: 10811 Kiter/s (12.39s user 4.71s system 9.25s wall 1.85 cores)
> 3 threads: 5353 Kiter/s (21.02s user 25.85s system 18.68s wall 2.51 cores)
> 4 threads: 4277 Kiter/s (27.12s user 54.89s system 23.38s wall 3.51 cores)
> 5 threads: 3861 Kiter/s (24.51s user 85.21s system 25.90s wall 4.24 cores)
> 6 threads: 3540 Kiter/s (20.37s user 125.47s system 28.25s wall 5.16 cores)
> 8 threads: 7257 Kiter/s (12.11s user 81.09s system 13.78s wall 6.76 cores)
> 10 threads: 8271 Kiter/s (10.87s user 90.33s system 12.09s wall 8.37 cores)
> 12 threads: 10965 Kiter/s (9.16s user 88.66s system 9.12s wall 10.73 cores)
> 16 threads: 14472 Kiter/s (7.24s user 95.69s system 6.91s wall 14.90 cores)
> 24 threads: 17331 Kiter/s (6.01s user 123.90s system 5.77s wall 22.51 cores)
> 32 threads: 18939 Kiter/s (5.60s user 155.93s system 5.28s wall 30.59 cores)
> 64 threads: 18727 Kiter/s (5.66s user 162.57s system 5.34s wall 31.50 cores)
> 128 threads: 18349 Kiter/s (5.56s user 167.46s system 5.45s wall 31.75 cores)
> 256 threads: 17271 Kiter/s (5.41s user 178.54s system 5.79s wall 31.77 cores)
> 512 threads: 16207 Kiter/s (5.15s user 191.55s system 6.17s wall 31.88 cores)
> 1024 threads: 14948 Kiter/s (4.72s user 208.38s system 6.69s wall 31.85 cores)

This test program looks really useful.

Would you be interested in adding it as a 'perf bench futex' testcase? 
That way kernel developers could monitor futex performance in the future 
as well.

See 'perf bench' in the latest perf events tree:

  http://people.redhat.com/mingo/tip.git/README

Do 'cd tools/perf; make -j install' to install perf.

	Ingo
