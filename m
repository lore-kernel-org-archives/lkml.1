Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYCUJyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYCUJyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYCUJyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:54:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYCUJyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:54:14 -0400
Date: Fri, 21 Mar 2008 10:53:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and
	smp_call_function_single()
Message-ID: <20080321095343.GA21409@elte.hu>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> The patch series is also available in the 'generic-ipi' branch from
> 
> git://git.kernel.dk/linux-2.6-block.git
> 
> and the 'io-cpu-affinity' branch is directly based on this.

i'm still wondering about the following fundamental bit: why not use per 
CPU kernel threads? That way you get a fast (lockless) IPI "for free" as 
SMP wakeups already do this.

smp_call_function() is quirky and has deep limitations on atomicity, 
etc., so we are moving away from it and should not base more 
functionality on it.

	Ingo
