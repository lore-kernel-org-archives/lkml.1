Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZFWJrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZFWJrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZFWJr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:47:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZFWJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:47:27 -0400
Date: Tue, 23 Jun 2009 11:47:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: eranian@gmail.com, "Wang, Yong Y" <yong.y.wang@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: perf_counter Atom patch
Message-ID: <20090623094717.GA30634@elte.hu>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com> <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com> <20090623075959.GA23534@ywang-moblin2.bj.intel.com> <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com> <7c86c4470906230140p35ce043fw24e0c20651568f31@mail.gmail.com> <20090623085321.GC23534@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623085321.GC23534@ywang-moblin2.bj.intel.com>
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Tue, Jun 23, 2009 at 10:40:45AM +0200, stephane eranian wrote:
> > Yong,
> > 
> > On Tue, Jun 23, 2009 at 10:27 AM, stephane
> > eranian<eranian@googlemail.com> wrote:
> > > Hi,
> > >
> > > On Tue, Jun 23, 2009 at 9:59 AM, Yong Wang<yong.y.wang@linux.intel.com> wrote:
> > >> On Tue, Jun 23, 2009 at 09:45:03AM +0200, stephane eranian wrote:
> > >>>
> > >>> Unfortunately, I don't have a N270 to compare with your results.
> > >>> We need to verify whether or not N270 implements the fixed counters.
> > >>> Does it report architected perfmon v3 or v1?
> > >>>
> > >>
> > >> All Atom processors report perfmon v3 as specified in SDM. N270 is no
> > >> exception.
> > >>
> > > V3 does not set a minimal number of fixed counters, could be zero. But
> > > that seems
> > > odd. Let me ask around.
> > >
> > Second thought on this:
> >        x86_pmu.num_counters_fixed      =
> > max((int)edx.split.num_counters_fixed, 3);
> > 
> >         rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
> > 
> > 
> > Forcing num_counter_fixed is not enough, you need to make sure 
> > they are actually activated in GLOBAL_CTRL, i.e., make sure bits 
> > 32-34 are set in intel_ctrl. Depending on which machine you're 
> > on, the power on value for GLOBAL_CTRL changes. The correct 
> > value for it should be that ONLY generic counters are on by 
> > default.
> > 
> 
> Oh, this might be why fixed counter do not work on my Atom box. I 
> will look into it. [...]

Thanks - having a different bootup default for the global ctrl 
indeed sounds like a good and plausible explanation - please send a 
patch for that if you've tested it, removing that quirk and adding 
the global-enable ctrl logic.

	Ingo
