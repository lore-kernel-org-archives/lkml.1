Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYLPVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYLPVTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYLPVTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:19:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:19:07 -0500
Date: Tue, 16 Dec 2008 22:18:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add command line init_start_cpus
Message-ID: <20081216211848.GO14787@elte.hu>
References: <4944A279.5020009@kernel.org> <87myeyfgb7.fsf@basil.nowhere.org> <86802c440812141939s2fe0fd9g5f9899ed9e4f6e6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440812141939s2fe0fd9g5f9899ed9e4f6e6c@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Dec 14, 2008 at 4:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Yinghai Lu <yinghai@kernel.org> writes:
> >
> >> Impact: new command line
> >>
> >> so could select cpus to be started during init stage
> >
> > maxcpus=N should do this already, at least for the first N cpus.
> > If you really need a non continuous range of N (why?) then it would
> > be better to fix maxcpus instead of adding a new option.
> 
> it seems it is hard to make maxcpus= to support random cpus selecting 
> and maxcpus=0 looks insane

yes, maxcpus=0 looks sucky. If we want this via a boot option then it 
should be a separate one.

> also maxcpus=1, will disable smp, can you enable other cpus later in 
> user space?

only booting maxcpus=0 or nosmp will disable SMP permanently. maxcpus=1 
should give the boot CPU [if not then we need to fix it], and you can then 
enable an arbitrary permutation of good CPUs via:

  echo 1 > /sys/devices/system/cpu/cpuX/online

as long as you CONFIG_HOTPLUG_CPU enabled.

What _might_ make sense is to introduce badcpus=2,4,6 that would 
permanently disnumerate all the broken CPUs, by striking that mask from 
the possible-cpus-map - inaccessible to hotplugging as well. (Note that by 
naming it in the inverse way the thing gets a whole new quality - the boot 
option in itself explains its purpose.)

	Ingo
