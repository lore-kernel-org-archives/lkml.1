Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZIJGxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZIJGxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZIJGxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:53:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZIJGxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:53:14 -0400
Date: Thu, 10 Sep 2009 08:53:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
Message-ID: <20090910065306.GB3920@elte.hu>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my53vo6d.fsf@depni.sinp.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > Thanks!
> >
> > I think we found the reason for that regression - would you mind 
> > to re-test with latest -tip, e157986 or later?
> >
> > If that works for you i'll describe our theory.
> >
> 
> Good job -- seems to work, thanks.  Regression is still about 3% 
> though: http://img3.imageshack.us/img3/5335/epicbfstip.png

Ok, thanks for the update. The problem is that i've run out of 
testsystems that can reproduce this. So we need your help to debug 
this directly ...

A good start would be to post the -tip versus BFS "perf stat" 
measurement results:

   perf stat --repeat 3 make -j4 bzImage

And also the -j8 perf stat result, so that we can see what the 
difference is between -j4 and -j8.

Note: please check out latest tip and do:

  cd tools/perf/
  make -j install

To pick up the latest 'perf' tool. In particular the precision of 
--repeat has been improved recently so you want that binary from 
-tip even if you measure vanilla .31 or .31 based BFS.

Also, it would be nice if you could send me your kernel config - 
maybe it's some config detail that keeps me from being able to 
reproduce these results. I havent seen a link to a config in your 
mails (maybe i missed it - these threads are voluminous).

	Ingo
