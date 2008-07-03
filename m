Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYGCPMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYGCPMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYGCPMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:12:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYGCPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:12:22 -0400
Date: Thu, 3 Jul 2008 17:12:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, peterz@infradead.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
Message-ID: <20080703151209.GA17059@elte.hu>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <20080630131511.GA7506@elte.hu> <4868DCC7.BA47.005A.0@novell.com> <20080703144124.GA653@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703144124.GA653@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > I may have found the issue: It looks like the hunk that initially 
> > disables interrupts in load_balance_newidle() was inadvertently 
> > applied to load_balance() instead during the merge to linux-tip.  If 
> > you fold the following patch into my original patch, it should set 
> > things right again.
> 
> ah, sorry - indeed! I've reactivated your patch and i'm testing it 
> now.

-tip testing found that it still hangs at:

 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#1.
 x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
 CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
 Brought up 2 CPUs
 Total of 2 processors activated (8044.97 BogoMIPS).
 [...]

with this config:

  http://redhat.com/~mingo/misc/config-Thu_Jul__3_16_49_53_CEST_2008.bad

on 3 separate test-systems.

I've again reverted both your fixup and the original commit. I've pushed 
out the failing tree to the tmp.sched/devel.fe6149f5e82 -tip branch, you 
should be able to reproduce it.

	Ingo
