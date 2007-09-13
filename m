Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXIMJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXIMJbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXIMJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:31:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXIMJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:31:47 -0400
Date: Thu, 13 Sep 2007 11:31:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913093137.GA31923@elte.hu>
References: <20070911200459.GA6974@elte.hu> <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com> <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com> <20070913090655.GA28505@elte.hu> <6b8cef970709130224t2f8d28d4mdfbf22ba10b42497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709130224t2f8d28d4mdfbf22ba10b42497@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Hussey <robjhussey@gmail.com> wrote:

> On 9/13/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > thanks for the numbers! Could you please also post the .config you used?
> 
> Sure, .config for 2.6.23-rc1 and 2.6.23-rc6 attached.

thx! If you've got some time, could you perhaps re-measure with these 
disabled:

  CONFIG_SCHED_DEBUG=y
  CONFIG_SCHEDSTATS=y

these options mask some of the performance enhancements we made. There's 
also a new code drop at:

   http://people.redhat.com/mingo/cfs-scheduler/devel/

with some fixes for SMP. (and you've got an SMP box it appears)

also, if you want to maximize performance, it usually makes more sense 
to build with these flipped around:

  # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
  CONFIG_FORCED_INLINING=y

i.e.:

  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
  # CONFIG_FORCED_INLINING is not set

because especially on modern x86 CPUs, smaller x86 code is faster. (and 
it also takes up less I-cache size)

	Ingo
