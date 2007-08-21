Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbXHUIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbXHUIf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXHUIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:35:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbXHUIfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:35:15 -0400
Date: Tue, 21 Aug 2007 10:35:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>, Willy Tarreau <w@1wt.eu>,
       Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070821083500.GA1144@elte.hu>
References: <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu> <Pine.LNX.4.64.0708102235320.1817@scrub.home> <20070810213630.GA13910@elte.hu> <20070811003052.GA18812@elte.hu> <Pine.LNX.4.64.0708191936110.1817@scrub.home> <1187681583.6183.25.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187681583.6183.25.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.4
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.4 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0229]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > It doesn't make much of a difference.
> 
> I thought this was history.  With your config, I was finally able to 
> reproduce the anomaly (only with your proggy though), and Ingo's patch 
> does indeed fix it here.
> 
> Freshly reproduced anomaly and patch verification, running 2.6.23-rc3 
> with your config, both with and without Ingo's patch reverted:
> 
> 6561 root      20   0  1696  492  404 S 32.0  0.0   0:30.83 0 lt
> 6562 root      20   0  1696  336  248 R 32.0  0.0   0:30.79 0 lt
> 6563 root      20   0  1696  336  248 R 32.0  0.0   0:30.80 0 lt
> 6564 root      20   0  2888 1236 1028 R  4.6  0.1   0:05.26 0 sh
> 
> 6507 root      20   0  2888 1236 1028 R 25.8  0.1   0:30.75 0 sh
> 6504 root      20   0  1696  492  404 R 24.4  0.0   0:29.26 0 lt
> 6505 root      20   0  1696  336  248 R 24.4  0.0   0:29.26 0 lt
> 6506 root      20   0  1696  336  248 R 24.4  0.0   0:29.25 0 lt

oh, great! I'm glad we didnt discard this as a pure sched_clock 
resolution artifact.

Roman, a quick & easy request: please send the usual cfs-debug-info.sh 
output captured while your testcase is running. (Preferably try .23-rc3 
or later as Mike did, which has the most recent scheduler code, it 
includes the patch i sent to you already.) I'll reply to your 
sleeper-fairness questions separately, but in any case we need to figure 
out what's happening on your box - if you can still reproduce it with 
.23-rc3. Thanks,

	Ingo
