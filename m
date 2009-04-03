Return-Path: <linux-kernel-owner+w=401wt.eu-S935632AbZDCRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935632AbZDCRs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbZDCRsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:48:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZDCRsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:48:17 -0400
Date: Fri, 3 Apr 2009 19:48:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: markus.t.metzger@intel.com, tglx@linutronix.de, hpa@zytor.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/20] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Message-ID: <20090403174806.GG6295@elte.hu>
References: <20090403144332.799740000@intel.com> <20090403153617.GA15166@elte.hu> <1238780693.6224.5.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238780693.6224.5.camel@raistlin>
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


* Markus Metzger <markus.t.metzger@googlemail.com> wrote:

> On Fri, 2009-04-03 at 17:36 +0200, Ingo Molnar wrote: 
> > * markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
> > 
> > > Patches 1-5 fix races with context switching code when the branch 
> > > traced task is currently running.
> > > 
> > > In the worst case, this might cause context switch code to access 
> > > freed memory or the tracing hardware to continue tracing into a 
> > > freed buffer. Both might crash the kernel.
> > > 
> > > The first 4 patches apply to .29 using the below preparation 
> > > patch.
> > > 
> > > The remaining patches fix bugs in the context of per-cpu tracing 
> > > (i.e. hw-branch-tracer) and pebs, add more selftest code, and do 
> > > some cleanups.
> > 
> > Thanks - this looks pretty acceptable. Latest -git changed a lot of 
> > code in the same area (-mm bits went upstream), creating a lot of 
> > conflicts.
> > 
> > To not prolongue this any longer (20 patches are difficult enough 
> > already to handle) i picked up your patches and resolved the 
> > conflicts in situ - mind having a look at the resulting 
> > tip:tracing/hw-branch-tracing branch - does the end result look sane 
> > to you?
> 
> Thanks,
> 
> The branch tracing bits in tip/tracing/hw-branch-tracing look good.
> The kernel boots (after changes, see below) and my tests pass.
> 
> A defconfig build fails with a compile error, though:
> In file included from net/core/skbuff.c:68:
> include/trace/skb.h:7: error: expected ‘)’ before ‘(’ token
> .....
> 
> Changing TP~ to TP_~ (as in tip/master) seems to do the trick.

Ah. Darn - i should have merged tracing/core into it. That will ruin 
bisectability... I'll redo it.

	Ingo
