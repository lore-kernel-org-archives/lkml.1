Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbZKXQdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbZKXQdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbZKXQdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:33:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35573 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbZKXQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:33:31 -0500
Message-ID: <4B0C0ACC.5050703@us.ibm.com>
Date: Tue, 24 Nov 2009 08:33:16 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Michel Lespinasse <walken@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] perf bench: Add new files for futex performance test
References: <20091118033741.GB23808@google.com> <1259073555-7312-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1259073555-7312-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> This patch adds two new files.
> 

Hi Hitoshi-san,

 > futextest.h provides general wrappers for futex() system call.
 > This patch containts the line:
 > typedef volatile u_int32_t futex_t;
 > I know that new typedef is not a thing to welcome,
 > but this is useful thing.
 >
 > futex-wait.c is a new suite to test performance of FUTEX_WAIT.
 >
 > These files are from Darren Hart's futex test,
 > and futex-wait.c is based on the program originally
 > written by Michel Lespinasse.

Thanks for looking at getting the futex performance tests into perf. 
Just wanted to make sure you are aware that there will likely be several 
more futextest/performance tests in the near future as the project is 
under early active development. I see you have merged harness.h into 
futex-wait.c, which is fine, but I will likely be adding a new 
include/locking.h to add things like barrier, lock, and lock_pi locking 
primitives to the futextest testsuite. futex-wait.c would then be 
updated to use those directly if feasible and remove the custom locking 
primitives in the test itself. I mention this so you are aware and perf 
futex benchmarks don't get too far out of sync with futextest.

I'd be interested in any ideas you have to make futextest/performance/* 
tests integrate more easily into perf as I'd like to include each new 
test into perf as well.

Couple of nits below:


> diff --git a/tools/perf/bench/futextest.h b/tools/perf/bench/futextest.h
> new file mode 100644
> index 0000000..09d8b94
> --- /dev/null
> +++ b/tools/perf/bench/futextest.h
> @@ -0,0 +1,280 @@
> +/******************************************************************************
> + *
> + *   Copyright B) International Business Machines  Corp., 2009


Copyright character issue...

> + * HISTORY
> + *      2009-Nov-24:
> + *       Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> + *      2009-Nov-06: Initial version by Darren Hart <dvhltc@us.ibm.com>

I usually add the dates in ascending chronological order.

> + *
> + *****************************************************************************/
> +
> +#ifndef _FUTEXTEST_H
> +#define _FUTEXTEST_H
> +
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +#include <sys/types.h>
> +#include <linux/futex.h>
> +
> +typedef volatile u_int32_t futex_t;

I have been considering making this into a val wrapped in a struct like 
the atomic_t as that will make adding things like flags to the futex_t 
easier. Again, just a head's up that it may be changing in the near future.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
