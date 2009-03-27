Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZC0Jmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZC0Jmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZC0Jm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:42:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZC0Jm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:42:26 -0400
Date: Fri, 27 Mar 2009 10:42:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] blktrace: last round of fixes
Message-ID: <20090327094207.GB8234@elte.hu>
References: <49CC6691.7050103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC6691.7050103@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> This is the last round of fixes for blktrace, I hope.  :) 
> 
> Changelog v1 -> v2:
>   - fix a bug in "blktrace: make classic output more classic",
>     and rebase other patches.
>   - re-order patches.
>   - a new patch for filtering BLK_TN_MESSAGE
> 
> 
> [PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
> [PATCH v2 2/6] blktrace: make classic output more classic
> [PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
> [PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace
> [PATCH v2 5/6] blktrace: extract duplidate code
> [PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly

thanks Li!

I think we can do the following ordering. First apply the fixes:

> [PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
> [PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
> [PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace

These mostly relate to mixed use of ioctl and ftrace based block 
tracing - which is rare but indeed possible. The fixes and cleanups 
you did to refcounting look good.

These bits:

> [PATCH v2 2/6] blktrace: make classic output more classic
> [PATCH v2 5/6] blktrace: extract duplidate code
> [PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly

are optional improvements. The BLK_TN_MESSAGE filter addition - 
Jens, are you fine with that feature addition? (it certainly looks 
like a nice thing to me.)

Also, note that we'll get even more in-kernel filtering capabilities 
in blktrace if we convert the tracepoints to TRACE_EVENT().

Reviewed-by: Ingo Molnar <mingo@elte.hu>

	Ingo
