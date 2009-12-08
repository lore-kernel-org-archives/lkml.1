Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZLHG60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZLHG60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZLHG6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:58:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZLHG6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:58:24 -0500
Date: Tue, 8 Dec 2009 07:58:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Timo Sirainen <tss@iki.fi>, WANG Cong <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-ID: <20091208065818.GB21340@elte.hu>
References: <20091208053851.GA12383@elte.hu>
 <20091208144004.B5AB.A69D9226@jp.fujitsu.com>
 <20091208155202.B5B7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208155202.B5B7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > 
> > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > 
> > > > > The feature looks useful, but the choice of a prctl as an API is strange 
> > > > > - it limits us to the current task only - while the ability to set 
> > > > > arguments for another task looks a more generic (and potentially more 
> > > > > useful) solution.
> > > > 
> > > > No. It's impossible.
> > > > /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
> > > > receive string, it receive virtual address itself. [...]
> > > 
> > > it's not 'impossible' at all, you yourself mention ptrace:
> > 
> > Ah yes, 'impossible' was wrong word. but it doesn't works intentionally.
> > 
> > 1. setproctitle() unaware application continue to see argv[0] directly.
> >   it makes some inconsistent behavior. 
> > 2. proc title (i.e. string) injection need to map new page as process title area.
> >    implicit mapping increasing makes new trouble
> >    - mihgt cause to exceed max_map_count awhile after.
> >    - might cause leak proc title area (who know when it should be freed?)
> > 
> > I think reasonable way is 1. send signal (or use another inter process
> > communication way) to target process 2. target process change own proc title
> > themself.
> > 
> > Plus, I haven't seen the use-case of changin another task. iow I doubt
> > it's worth to change lots code.
> 
> if your mention is strongly, can you please explain your expected use 
> case?

I have no strong opinion - i just raised the possibility. We try to 
avoid special-purpose APIs for new syscalls - we try to design them in a 
generic way.

	Ingo
