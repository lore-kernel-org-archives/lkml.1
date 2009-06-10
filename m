Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZFJKoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZFJKoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZFJKoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:44:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZFJKoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:44:15 -0400
Date: Wed, 10 Jun 2009 12:44:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Fix incorrect default branch
Message-ID: <20090610104409.GC27724@elte.hu>
References: <20090609074621.GA19290@ywang-moblin2.bj.intel.com> <20090609132313.GE25586@elte.hu> <20090609133232.GA14642@ywang-moblin2.bj.intel.com> <20090609142506.GD32703@elte.hu> <20090610051521.GB30923@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610051521.GB30923@ywang-moblin2.bj.intel.com>
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

> On Tue, Jun 09, 2009 at 04:25:06PM +0200, Ingo Molnar wrote:
> > 
> > They dont have X86_FEATURE_ARCH_PERFMON set, right?
> > 
> > I made the switch statement under the assumption that it covers all 
> > existing arch-perfmon CPU models. If not, the 'default:' placement 
> > would indeed be buggy.
> > 
> 
> OK, you are right. X86_FEATURE_ARCH_PERFMON eliminates all the old CPUs.
> However, the logic still seems not correct. Both the Core2 CPUs I'm
> using are recognized as Nehalem/Corei7. /proc/cpuinfo and cpuid outputs
> are given below.
> 
> The first one:
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
> stepping        : 6
> 
> CPUID.0x00000001: eax=0x00010676
> 
> The second one:
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> stepping        : 6
> 
> CPUID.0x00000001: eax=0x000006f6
> 
> Looks like it's not enough to just look at boot_cpu_data.x86_model.

Yeah - i've applied the patch you sent, thanks. I'm mostly working 
on NHM so i didnt notice.

	Ingo
