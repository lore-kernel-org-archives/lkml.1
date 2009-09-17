Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZIQHVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZIQHVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbZIQHVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:21:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488AbZIQHVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:21:18 -0400
Date: Thu, 17 Sep 2009 09:21:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patchlet] Re: Epic regression in throughput since v2.6.23
Message-ID: <20090917072117.GA17198@elte.hu>
References: <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru> <20090916194507.GA27456@elte.hu> <87fxamiim4.fsf@depni.sinp.msu.ru> <1253163339.15767.62.camel@marge.simson.net> <1253164000.15767.65.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253164000.15767.65.camel@marge.simson.net>
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


here's some start-debit versus non-start-debit numbers.

The workload: on a dual-core box start and kill 10 loops, once every 
second. PID 23137 is a shell doing interactive stuff. (running a loop of 
usleep 100000 and echo)

START_DEBIT:

europe:~> perf sched lat | grep 23137
  bash:23137            |     34.380 ms |      187 | avg:    0.005 ms | max:    0.017 ms |
  bash:23137            |     36.410 ms |      188 | avg:    0.005 ms | max:    0.011 ms |
  bash:23137            |     36.680 ms |      183 | avg:    0.007 ms | max:    0.333 ms |

NO_START_DEBIT:

europe:~> perf sched lat | grep 23137
  bash:23137            |     35.531 ms |      183 | avg:    0.005 ms | max:    0.019 ms |
  bash:23137            |     35.511 ms |      188 | avg:    0.007 ms | max:    0.334 ms |
  bash:23137            |     35.774 ms |      185 | avg:    0.005 ms | max:    0.019 ms |

Seems very similar at first sight.

	Ingo
