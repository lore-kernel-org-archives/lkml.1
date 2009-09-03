Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZICRQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZICRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZICRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZICRQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:16:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	<x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
	<x49ab1cxcma.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0909030947m2423d0cdr5fd2b3de261b2da6@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Sep 2009 13:16:43 -0400
In-Reply-To: <4e5e476b0909030947m2423d0cdr5fd2b3de261b2da6@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 3 Sep 2009 18:47:46 +0200")
Message-ID: <x49ws4gvthg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> can you share the benchmark?

Of course, how miserly of me!

http://people.redhat.com/jmoyer/cfq-regression-tests-0.0.1.tar.gz

> I think I have to fix the min slice to consider priority, too, to
> respect the priorities when there are many processes.
>
> For the fairness at a single priority level, my tests show that
> fairness is improved with the patches (comparing minimum and maximum
> bandwidth for a set of 32 processes):
>
> Original:
> Run status group 0 (all jobs):
>    READ: io=14192KiB, aggrb=480KiB/s, minb=7KiB/s, maxb=20KiB/s,
> mint=30001msec, maxt=30258msec
>
> Run status group 1 (all jobs):
>    READ: io=829292KiB, aggrb=27816KiB/s, minb=723KiB/s,
> maxb=1004KiB/s, mint=30004msec, maxt=30529msec
>
> Adaptive:
> Run status group 0 (all jobs):
>    READ: io=14444KiB, aggrb=488KiB/s, minb=12KiB/s, maxb=17KiB/s,
> mint=30003msec, maxt=30298msec
>
> Run status group 1 (all jobs):
>    READ: io=721324KiB, aggrb=24140KiB/s, minb=689KiB/s, maxb=795KiB/s,
> mint=30003msec, maxt=30598msec
>
> Are you using random think times? This could explain the discrepancy.

No, it's just a sync read benchmark.  It's the be4-x-8.fio job file in
the tarball mentioned above.  Note that the run-time is only 10 seconds,
so maybe that's not enough to get accurate data?  If you try increasing
it, be careful that you don't read in the entire file and wrap back
around, as this is a buffered read test, that will skew the results.

Cheers,
Jeff
