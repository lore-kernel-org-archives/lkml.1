Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXLUXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXLUXVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXLUXV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:21:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXLUXV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:21:27 -0500
Date: Sat, 22 Dec 2007 00:17:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071221231728.GA28008@elte.hu>
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com> <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And now, can the people who made the problem reports and complained 
> about SLUB please test the patch - the ball is now in your court!

yep, and i ran a quick comparison test on a 2-core box with 3 kernels:

  [ best of 5 runs in a row which had a relative jitter of less than 10% ]

     MIN      v2.6.24.slab     v2.6.24.slub v2.6.24.slub.fix
  ----------------------------------------------------------
           mmap:    429.00    402.00 ( -6%)    385.00 (-10%)
         select:     11.38     10.46 ( -8%)     11.41 (  0%)
      proc-exec:    121.52    116.77 ( -3%)    120.77 (  0%)
      proc-fork:    106.84    106.19 (  0%)    107.92 (  1%)
   syscall-open:      3.09      3.13 (  1%)      3.25 (  4%)
   hackbench-50:      2.85      3.47 ( 21%)      2.88 (  1%)

and the regression seems to be largely fixed! Not only is the hackbench 
one fixed, but mmap shows an above-noise improvement as well.

Acked-by: Ingo Molnar <mingo@elte.hu>

And i hereby nominate Pekka as SLUB/SLAB co-maintainer and spokesperson 
;-)

	Ingo
