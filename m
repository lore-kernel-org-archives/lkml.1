Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZC3BYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZC3BYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZC3BXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:23:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58278 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZC3BXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:23:50 -0400
Date: Mon, 30 Mar 2009 03:23:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] blktrace: last round of fixes
Message-ID: <20090330012337.GC11087@elte.hu>
References: <49CC6691.7050103@cn.fujitsu.com> <20090328224640.GA2465@elte.hu> <49D014F9.8000404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D014F9.8000404@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> This is the last round of fixes for blktrace, I hope.  :) 
> >>
> >> Changelog v1 -> v2:
> >>   - fix a bug in "blktrace: make classic output more classic",
> >>     and rebase other patches.
> >>   - re-order patches.
> >>   - a new patch for filtering BLK_TN_MESSAGE
> >>
> >> [PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
> >> [PATCH v2 2/6] blktrace: make classic output more classic
> >> [PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
> >> [PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace
> >> [PATCH v2 5/6] blktrace: extract duplidate code
> >> [PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly
> >> ---
> >>  blktrace.c     |  188 +++++++++++++++++++++++++++++++++------------------------
> >>  trace_output.c |    6 -
> >>  trace_output.h |    5 -
> >>  3 files changed, 117 insertions(+), 82 deletions(-)
> > 
> > Li, Jens - what's your call for v2.6.30, can the blktrace changes go 
> > upstream or should i zap the whole thing?
> > 
> 
> It should be fine to merge tip/blktrace into .30, and we still 
> have 2 month to fix remaining bugs, if any.

ok.

Although regarding instrumentation patches we carry in -tip we aim 
to enforce perfect stability right at the point of the merge window. 

One major point of instrumentation is to find kernel bugs ... and 
it's self-defeating if instrumentation is buggy itself! By the time 
the stable kernel is released the most important kernel bugs are 
fixed already so having stable instrumentation by that moment is too 
late.

So we've got extensive self-tests and other measures in place to 
ensure stability.

( The mixed blktrace ioctl/ftrace plugin usage model fell a bit
  outside of the expectation of these stability tests though, hence
  this relatively slow and late stabilization curve there. It still 
  looks all fine for .30 to me too. )

	Ingo
