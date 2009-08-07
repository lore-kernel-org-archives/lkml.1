Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZHGL0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZHGL0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHGL0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:26:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZHGL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:26:45 -0400
Date: Fri, 7 Aug 2009 13:26:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090807112634.GC30014@elte.hu>
References: <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu> <20090804113555.GA28198@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com> <1249633282.32113.613.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com> <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
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


btw., the number of samples seems to be varying too widely:

titan:~> for ((i=0;i<10;i++)); do perf record -f -e branches:u -c 1 true 2>/dev/null; perf report | head -1; done
# Samples: 28784
# Samples: 24063
# Samples: 22788
# Samples: 30449
# Samples: 15335
# Samples: 30557
# Samples: 24010
# Samples: 23866
# Samples: 24877
# Samples: 24330

compared to the branch-stat itself:

titan:~> perf stat -v --repeat 10 -e branches:u true
[ perf stat: executing run #1 ... ]
[ perf stat: executing run #2 ... ]
[ perf stat: executing run #3 ... ]
[ perf stat: executing run #4 ... ]
[ perf stat: executing run #5 ... ]
[ perf stat: executing run #6 ... ]
[ perf stat: executing run #7 ... ]
[ perf stat: executing run #8 ... ]
[ perf stat: executing run #9 ... ]
[ perf stat: executing run #10 ... ]

 Performance counter stats for 'true' (10 runs):

          23851  branches                   ( +-   0.000% )

    0.000639653  seconds time elapsed   ( +-   2.474% )

do we lose records in the recording?

	Ingo
