Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbXJGTdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbXJGTdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXJGTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:33:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbXJGTdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:33:17 -0400
Date: Sun, 7 Oct 2007 21:32:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, btrace <linux-btrace@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux Kernel Markers - performance characterization with large
	IO load on large-ish system
Message-ID: <20071007193256.GA18558@elte.hu>
References: <46F92219.9020406@hp.com> <20070925171349.GA6057@Krystal> <46FA7A86.6090804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA7A86.6090804@hp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:

>  o  All kernels start off with Linux 2.6.23-rc6 + 2.6.23-rc6-mm1
> 
>  o  '- bt cfg' or '+ bt cfg' means a kernel without or with blktrace 
> configured respectively.
> 
>  o  '- markers' or '+ markers' means a kernel without or with the 
> 11-patch marker series respectively.
> 
> 38 runs without blk traces being captured (dropped hi/lo value from 40 runs)
> 
> Kernel Options       Min val    Avg val    Max val    Std Dev
> ------------------  ---------  ---------  ---------  ---------
> - markers - bt cfg  15.349127  16.169459  16.372980   0.184417
> + markers - bt cfg  15.280382  16.202398  16.409257   0.191861
> 
> - markers + bt cfg  14.464366  14.754347  16.052306   0.463665
> + markers + bt cfg  14.421765  14.644406  15.690871   0.233885

actually, the pure marker overhead seems to be a regression:

> - markers - bt cfg  15.349127  16.169459  16.372980   0.184417
> + markers - bt cfg  15.280382  16.202398  16.409257   0.191861

why isnt the marker near zero-cost as it should be? (as long as they are 
enabled but are not in actual use) 2% increase is _ALOT_. That's the 
whole point of good probes: they do not slow down the normal kernel.

_Worst case_ it should be at most a few instructions overhead but that 
does not explain the ~2% wall-clock time regression you measured here.

So there's something wrong going on - either markers have unacceptably 
high cost, or the measurement is not valid.

	Ingo
