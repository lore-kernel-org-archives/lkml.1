Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbXLKOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbXLKOeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXLKOeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:34:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXLKOeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:34:01 -0500
Date: Tue, 11 Dec 2007 15:33:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071211143336.GA17866@elte.hu>
References: <1197049846.1645.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197049846.1645.68.camel@localhost.localdomain>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hackbench seems to show this regression the most. In my tests I didn't 
> see much change with kernel builds and such, but the focus was on 
> scheduling not memory management. I'll run my kernel tests next for 
> both SLAB and SLUB and see if there's any difference there.

i just ran various benchmarks on an 8-way (8x 700 MHz Xeon, 4GB RAM):

      AVG      v2.6.24.slab     v2.6.24.slub         [ smaller is better ]
   -----------------------------------------
            mmap:   1052.66          1049.33   (  0%)
           ctx-2:      4.32             4.30   (  0%)
          select:     41.95            43.69   (  4%)
       proc-exec:    394.45           391.92   (  0%)
    hackbench-10:      1.12             2.99   (166%)
    hackbench-20:      2.04             6.67   (226%)
    hackbench-50:      5.03            17.50   (247%)

and hackbench overhead stands out, by a huge margin. Other stuff is 
within measurement noise. Neither SLUB nor SLAB debugging was turned on, 
all other debugging options were off too.

	Ingo
