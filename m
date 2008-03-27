Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYC0KIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYC0KIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYC0KIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:08:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYC0KIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:08:38 -0400
Date: Thu, 27 Mar 2008 11:08:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and
	smp_call_function_single()
Message-ID: <20080327100802.GD15003@elte.hu>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321131558.GA15355@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> which is pretty much identical to io-cpu-affinity, except it uses 
> kernel threads for completion.
> 
> The reason why I dropped the kthread approach is that it was slower. 
> Time from signal to run was about 33% faster with IPI than with 
> wake_up_process(). Doing benchmark runs, and the IPI approach won 
> hands down in cache misses as well.

with irq threads we'll have all irq context run in kthread context 
again. Could you show me how you measured the performance of the kthread 
approach versus the raw-IPI approach?

we can do a million kthread context switches per CPU per second, so 
kthread context-switch cost cannot be a true performance limit, unless 
you micro-benchmarked this.

	Ingo
