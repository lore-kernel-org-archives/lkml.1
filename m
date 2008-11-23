Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYKWNPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYKWNPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYKWNPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:15:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbYKWNPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:15:06 -0500
Date: Sun, 23 Nov 2008 14:14:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Bug #11996] Tracing framework regression in 2.6.28-rc3
Message-ID: <20081123131449.GC1178@elte.hu>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.-hC.u7HKJB@chimera> <20081123151258.2e5ed008@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123151258.2e5ed008@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> On Sat, 22 Nov 2008 21:28:17 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
> > Subject		: Tracing framework regression in 2.6.28-rc3
> > Submitter	: Pekka Paalanen <pq@iki.fi>
> > Date		: 2008-11-09 10:13 (14 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
> > Handled-By	: Steven Rostedt <rostedt@goodmis.org>
> 
> Tested 2.6.28-rc6, this bug is fixed.

via:

commit ee51a1de7e3837577412be269e0100038068e691
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Nov 13 14:58:31 2008 +0100

    tracing: fix mmiotrace resizing crash
    
    Pekka reported a crash when resizing the mmiotrace tracer (if only
    mmiotrace is enabled).
    
    This happens because in that case we do not allocate the max buffer,
    but we try to use it.
    
    Make ring_buffer_resize() idempotent against NULL buffers.
    
    Reported-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

	Ingo
