Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZFVPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZFVPgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFVPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:36:13 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:43234 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZFVPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:36:12 -0400
Date: Mon, 22 Jun 2009 17:36:11 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090622173611.3b583c95@skybase>
In-Reply-To: <20090622152937.GA17512@elte.hu>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
	<20090622162631.4b4dcee4@skybase>
	<20090622144110.GA9771@elte.hu>
	<20090622165936.0bb776e1@skybase>
	<20090622150553.GA14363@elte.hu>
	<20090622171834.0df64aea@skybase>
	<20090622152937.GA17512@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 17:29:37 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Mon, 22 Jun 2009 17:05:53 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > 
> > > > On Mon, 22 Jun 2009 16:41:10 +0200
> > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > Hm, this is rather ugly. Why not use hrtimers like 'perf' does when 
> > > > > it fallback-samples based on the timer tick?
> > > > > 
> > > > > That method has three advantages:
> > > > > 
> > > > >  - no weird hookery needed
> > > > >  - resolution can go far beyond HZ
> > > > >  - it is evidently dynticks-safe
> > > > 
> > > > Hmm, if we replace the HZ based oprofile tick with an hrtimer we 
> > > > should add an interface to configure the sample interval as well, 
> > > > no? Otherwise we just replace one timer event (HZ) with another 
> > > > (hrtimer).
> > > 
> > > Even if the hrtimer is set with a 1/HZ period it's a better 
> > > solution, as it's dynticks safe without invasive changes.
> > 
> > Ok, but the patch will be quite big. All the profile_tick() calls 
> > from the architecture files will have to be removed. [...]
> 
> Hey, that's a bonus :)

It would remove some oddball code :-)
 
> > [...] And if we really want to keep things separate there will be 
> > two sets of per-cpu hrtimer, one for the old style profiler and 
> > one for oprofile. Any preference for the user space interface to 
> > set the sample rate? A sysctl?
> 
> I dont think we want to keep things separate. Regarding old-style 
> profiler, does anyone still use it? There's now a superior in-tree 
> replacement for it, so we could phase it out.

Well, for my part I won't miss it. But to be able to remove the 
profile_tick() calls from the architectures I either have to rip out
the old profiler now, or adapt it to use hrtimer as well.
 
> A sysctl sounds like the most obvious way to set the sample period - 
> and it can default to 1/Hz.

Agreed.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

