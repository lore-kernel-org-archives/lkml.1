Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZDGJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZDGJX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGJXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:23:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZDGJXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:23:47 -0400
Date: Tue, 7 Apr 2009 11:23:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] various perf counter bits
Message-ID: <20090407092333.GB17301@elte.hu>
References: <20090406094458.977814421@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406094458.977814421@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another thing i noticed is that our CPU migration counters look a 
bit weird:

aldebaran:~/linux/linux/Documentation/perf_counter> taskset 1 perfstat ls
design.txt  kerneltop  kerneltop.c  Makefile  perfstat

 Performance counter stats for 'ls':

       0.686802  task clock ticks     (msecs)
              3  context switches     (events)
              4  CPU migrations       (events)
            285  pagefaults           (events)
        2183899  CPU cycles           (events)
        1492516  instructions         (events)
          24638  cache references     (events)
           1763  cache misses         (events)

 Wall-clock time elapsed:     0.694796 msecs


the 'taskset 1' binds perfstat to a single CPU - still we had 4 
cross-CPU migrations?

	Ingo
