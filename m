Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYL3Fn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYL3Fn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 00:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYL3FnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 00:43:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYL3FnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 00:43:19 -0500
Date: Tue, 30 Dec 2008 06:42:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rusty Russell <rusty@au1.ibm.com>
Subject: Re: [PATCH] futex: add WARN_ON to catch certain assymetric
	(get|put)_futex_key calls
Message-ID: <20081230054257.GC11037@elte.hu>
References: <20081230034320.24404.56248.stgit@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230034320.24404.56248.stgit@Aeon>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> Following up on my previous key reference accounting patches, this patch
> will catch puts on keys that haven't been "got".  This won't catch nested
> get/put mismatches though.
> 
> Build and boot tested, with minimal desktop activity and a run of the
> open_posix_testsuite in LTP for testing.  No warnings logged.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: "Peter Zijlstra" <peterz@infradead.org>
> Cc: "Thomas Gleixner" <tglx@linutronix.de>
> Cc: "Rusty Russell" <rusty@au1.ibm.com>
> ---
> 
>  kernel/futex.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

applied to tip/core/futexes, thanks!

I changed this:

> +		WARN_ON(1);
>  		return;

to WARN_ON_ONCE() - warning once per bootup is good enough for 
kerneloops.org to pick it up, while a ton of warnings add no extra (other 
than to inconvenience the user, or even make the system unworkable).

	Ingo
