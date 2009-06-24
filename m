Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbZFXMsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbZFXMsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZFXMsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:48:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZFXMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:48:00 -0400
Date: Wed, 24 Jun 2009 14:47:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624124755.GC32306@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624121750.GB20564@elte.hu> <20090624122533.GA9510@linux-sh.org> <19010.7860.240329.636708@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19010.7860.240329.636708@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Paul Mundt writes:
> 
> > Yes, that all works fine. My comment was more in reference to 
> > the hardware performance counters that don't have IRQs of their 
> > own, which still need to be tied in to the perf_counter API.
> 
> For them you would need to check in hw_perf_counter_init() that 
> counter->attr.sample_period is zero, and fail with an -EINVAL 
> error if it isn't.

That would make 'perf stat' work - but 'perf top' and 'perf record' 
would not.

But those can be made to work as well without hw IRQ support, if the 
period is simply fed into a special hrtimer, with nanosecs units. 
The resulting sampling wont be "constant period" - but none of the 
tools really mind about that.

	Ingo
