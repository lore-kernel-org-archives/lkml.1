Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXEVLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXEVLVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXEVLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:21:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbXEVLVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:21:03 -0400
Date: Tue, 22 May 2007 13:20:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070522112008.GA16308@elte.hu>
References: <20070522092439.GA19895@elte.hu> <559665.2852.qm@web52608.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <559665.2852.qm@web52608.mail.re2.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:

> Compiled slub with SMP & CONFIG_PROVE_LOCKING. No luck. It still hangs 
> solid after the second spinlock lockup call trace.

hm. This suggests that the spinlock got corrupted - otherwise lockdep 
would have complained about the lockup before the spinlock-debug code 
had its chance.

> Surprisingly, with CONFIG_SMP=n, CONFIG_PROVE_LOCKING produces this 
> with slub (then hangs solid):

yes - PROVE_LOCKING reactivates spinlocks even on UP. At least this 
suggests that you'd have gotten the hang even with maxcpus=1 - i.e. the 
spinlock corruption is not caused by some genuine SMP race.

furthermore, PROVE_LOCKING also turns on DEBUG_LOCK_ALLOC, so we now 
know that it's most likely not use-after-free type of corruption.

	Ingo
