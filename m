Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZFIOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZFIOZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZFIOZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:25:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZFIOZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:25:13 -0400
Date: Tue, 9 Jun 2009 16:25:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Fix incorrect default branch
Message-ID: <20090609142506.GD32703@elte.hu>
References: <20090609074621.GA19290@ywang-moblin2.bj.intel.com> <20090609132313.GE25586@elte.hu> <20090609133232.GA14642@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609133232.GA14642@ywang-moblin2.bj.intel.com>
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

> On Tue, Jun 09, 2009 at 03:23:13PM +0200, Ingo Molnar wrote:
> > 
> > * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > 
> > > The event selector and UMASK values of Nehalem do not apply to all 
> > > Intel processors.
> > 
> > The idea was to offer _some_ sort of table on new CPUs, instead of 
> > nothing...
> > 
> > Eventually Intel stops changing those model specific index values in 
> > future CPUs and puts them into architectural perfmon, for 
> > fundamental stats like L1/LLC cache statistics.
> > 
> > In that case defaulting to the latest (known) enumeration might work 
> > out to be just the thing used by all future CPUs.
> > 
> > So this is a subtle hint ;-)
> > 
> 
> I see what you mean. You talked about future cpus. But what about 
> those old ones that are not atom, core2 or nehalem? Forget about 
> them?

They dont have X86_FEATURE_ARCH_PERFMON set, right?

I made the switch statement under the assumption that it covers all 
existing arch-perfmon CPU models. If not, the 'default:' placement 
would indeed be buggy.

	Ingo
