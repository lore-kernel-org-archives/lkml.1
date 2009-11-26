Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZKZFyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZKZFyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZKZFyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:54:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65191 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZKZFyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:54:07 -0500
Date: Thu, 26 Nov 2009 14:53:38 +0900 (JST)
Message-Id: <20091126.145338.189277946042751963.mitake@dcl.info.waseda.ac.jp>
To: dvhltc@us.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, walken@google.com,
       a.p.zijlstra@chello.nl, paulus@samba.org, fweisbec@gmail.com
Subject: Re: [PATCH 2/3] perf bench: Add new files for futex performance
 test
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <4B0C0ACC.5050703@us.ibm.com>
References: <20091118033741.GB23808@google.com>
	<1259073555-7312-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<4B0C0ACC.5050703@us.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 2/3] perf bench: Add new files for futex performance test
Date: Tue, 24 Nov 2009 08:33:16 -0800

Hi Darren,

> 
> Hitoshi Mitake wrote:
> > This patch adds two new files.
> > 
> 
> Hi Hitoshi-san,
> 
>  > futextest.h provides general wrappers for futex() system call.
>  > This patch containts the line:
>  > typedef volatile u_int32_t futex_t;
>  > I know that new typedef is not a thing to welcome,
>  > but this is useful thing.
>  >
>  > futex-wait.c is a new suite to test performance of FUTEX_WAIT.
>  >
>  > These files are from Darren Hart's futex test,
>  > and futex-wait.c is based on the program originally
>  > written by Michel Lespinasse.
> 
> Thanks for looking at getting the futex performance tests into perf. 
> Just wanted to make sure you are aware that there will likely be several 
> more futextest/performance tests in the near future as the project is 
> under early active development. I see you have merged harness.h into 
> futex-wait.c, which is fine, but I will likely be adding a new 
> include/locking.h to add things like barrier, lock, and lock_pi locking 
> primitives to the futextest testsuite. futex-wait.c would then be 
> updated to use those directly if feasible and remove the custom locking 
> primitives in the test itself. I mention this so you are aware and perf 
> futex benchmarks don't get too far out of sync with futextest.
> 
> I'd be interested in any ideas you have to make futextest/performance/* 
> tests integrate more easily into perf as I'd like to include each new 
> test into perf as well.
> 

There are two reasons why I changed and merged harness.h into futex-wait.c.
1) Thread numbers are fixed
2) Output style are fixed
But it seems that there is no other problem.
So I wrote the patch making locktest() more general.
I'll post it later in this thread, could you review this?

> Couple of nits below:
> 
> 
> > diff --git a/tools/perf/bench/futextest.h b/tools/perf/bench/futextest.h
> > new file mode 100644
> > index 0000000..09d8b94
> > --- /dev/null
> > +++ b/tools/perf/bench/futextest.h
> > @@ -0,0 +1,280 @@
> > +/******************************************************************************
> > + *
> > + *   Copyright B) International Business Machines  Corp., 2009
> 
> 
> Copyright character issue...

Sorry again...

> 
> > + * HISTORY
> > + *      2009-Nov-24:
> > + *       Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > + *      2009-Nov-06: Initial version by Darren Hart <dvhltc@us.ibm.com>
> 
> I usually add the dates in ascending chronological order.

Sorry, I'll fix it.

> 
> > + *
> > + *****************************************************************************/
> > +
> > +#ifndef _FUTEXTEST_H
> > +#define _FUTEXTEST_H
> > +
> > +#include <unistd.h>
> > +#include <sys/syscall.h>
> > +#include <sys/types.h>
> > +#include <linux/futex.h>
> > +
> > +typedef volatile u_int32_t futex_t;
> 
> I have been considering making this into a val wrapped in a struct like 
> the atomic_t as that will make adding things like flags to the futex_t 
> easier. Again, just a head's up that it may be changing in the near future.

Of course I'll chase your changes in the future :)

Thanks
	Hitoshi

