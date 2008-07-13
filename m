Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYGMSTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYGMSTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYGMSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:19:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYGMSTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:19:37 -0400
Date: Sun, 13 Jul 2008 20:19:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080713181910.GA22052@elte.hu>
References: <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com> <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com> <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org> <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com> <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org> <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> > So instead of this illogical and crazy mess:
> >
> >        +       switch (phase) {
> >        +       case CPU_UP_CANCELED:
> >        +       case CPU_UP_CANCELED_FROZEN:
> >        +       case CPU_DOWN_FAILED:
> >        +       case CPU_DOWN_FAILED_FROZEN:
> >        +       case CPU_ONLINE:
> >        +       case CPU_ONLINE_FROZEN:
> >        +       case CPU_DEAD:
> >        +       case CPU_DEAD_FROZEN:
> >        +               common_cpu_mem_hotplug_unplug(1);
> >
> > it should just say
> >
> >        +       switch (phase) {
> >        +       case CPU_ONLINE:
> >        +       case CPU_ONLINE_FROZEN:
> >        +       case CPU_DEAD:
> >        +       case CPU_DEAD_FROZEN:
> >        +               common_cpu_mem_hotplug_unplug(1);
> >
> > because it only makes sense to rebuild the scheduler domains when the
> > thing SUCCEEDS.
> >
> > See? By having a sane design, the code is not just more robust and 
> > easy to follow, you can also simplify it and make it more logical.
> 
> Yes, I agree. And I did _not_ say that the current design is sane. My 
> impression about changes acceptable during a late release cycle was 
> utterly CRAPPY (indeed, it's always better to immediately fix a 
> problem the right way, not just add another patch and pray it doesn't 
> break somewhere else).

mind sending Linus's patch as a completed patchset against tip/master 
(or tip/sched/devel) so that we can do it in early v2.6.27?

i still think your cpusets.c fix is what we should do for v2.6.26, given 
that there's agreement about how to fix it for real and thus in terms of 
regression/bug risk your patch is lower-impact and CPU hotplug has been 
broken for such a long time.

But we should follow it up with Linus's patch immediately afterwards in 
v2.6.27. Hm?

	Ingo
