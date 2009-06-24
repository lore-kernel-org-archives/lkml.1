Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZFXMSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZFXMSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZFXMSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:18:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbZFXMSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:18:00 -0400
Date: Wed, 24 Jun 2009 14:17:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624121750.GB20564@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624112929.GB2079@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> In practice oprofile has never been a good fit for these sorts of 
> counters, so this has fairly limited use. If there's a way to 
> wiggle these types of counters in to the new perf_counter API, 
> then I'll convert that over and just kill the old oprofile driver 
> off completely. Barring that, I'll just end up converting it over 
> to hrtimers as well, so don't let that stop you from ripping out 
> the timer hook bits.
> 
> Most of this code predates hrtimers anyways, and it also predates 
> the timer hook, which is only something that we converted to some 
> years back.

Note, the current initial upstream SH support for perfcounters:

 arch/sh/include/asm/perf_counter.h:#define set_perf_counter_pending()	do { } while (0)
 arch/sh/include/asm/unistd_32.h:#define __NR_perf_counter_open	336
 arch/sh/include/asm/unistd_64.h:#define __NR_perf_counter_open	364
 arch/sh/kernel/syscalls_32.S:	.long sys_perf_counter_open
 arch/sh/kernel/syscalls_64.S:	.long sys_perf_counter_open

Should already give you hrtimers straight away.

To test it, could you try to run 'perf top' after:

	cd tools/perf/
	make install

It should display a hrtimer driven kernel profile already. You can 
increase/decrease the frequency of sampling by using -F option - say 
'perf top -F 10000' should sample at 10 KHz.

Please let me know if any of this does not work as expected.

	Ingo
