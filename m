Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbYCSWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbYCSWev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbYCSVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:06:33 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55956 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbYCSVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:06:32 -0400
Date: Wed, 19 Mar 2008 14:48:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: VolanoMark performance improvements (was: Re: volanoMark 12%
	regression with 2.6.25-rc6)
Message-ID: <20080319134813.GA25197@elte.hu>
References: <1205831650.3215.569.camel@ymzhang> <20080318195807.GA26887@elte.hu> <1205892420.3215.594.camel@ymzhang> <20080319021555.GA15825@elte.hu> <1205896722.3215.624.camel@ymzhang> <20080319032854.GA20793@elte.hu> <1205901807.3215.659.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205901807.3215.659.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i just tried a handful of kernels with VolanoMark on an Intel quad-core 
testbox, using java-1.6.0-openjdk-1.6.0.0-0.4.b06.fc9.

The result: v2.6.25 is the fastest ever Linux kernel in VolanoMark 
testing, -rc7-to-be is ~41% faster than v2.6.24.2, and ~59% faster than 
v2.6.21, in this Java benchmark:

v2.6.25-rc7-to-be:

  Average throughput = 145613 messages per second
  Average throughput = 142569 messages per second
  Average throughput = 144963 messages per second
  Average throughput = 144998 messages per second
  Average throughput = 144213 messages per second
  Average throughput = 144491 messages per second

v2.6.24.2:

  Average throughput = 101351 messages per second
  Average throughput =  99247 messages per second
  Average throughput = 101155 messages per second
  Average throughput = 103905 messages per second
  Average throughput =  98345 messages per second
  Average throughput = 102775 messages per second

v2.6.21:

  Average throughput =  87630 messages per second
  Average throughput =  91366 messages per second
  Average throughput =  91317 messages per second
  Average throughput =  91317 messages per second
  Average throughput =  91359 messages per second
  Average throughput =  92116 messages per second

these numbers are totally reproducible when running them over a long 
time, i only included 6 runs for brevity. (A sidenote: the 
/proc/sys/kernel/compat_sched_yield switch of 0 or 1 has no effect on 
the .25-rc7 results, and it degraded the .24 results by about 35% so i 
kept it off there.)

so i can see no 12% regression at all - but i have not tried all the 
zillions of older, binary-only Java distributions.

So, to make the tests comparable, and to make some progress on this 
matter, could you please try java-1.6.0-openjdk - what kind of 
VolanoMark numbers do you get with it? If you still see a regression 
with an open Java package too then could you please send me the .config 
of your test-kernel? Thanks,

	Ingo
