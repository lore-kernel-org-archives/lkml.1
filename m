Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbZJGUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbZJGUA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbZJGUA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:00:57 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:55348 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZJGUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:00:56 -0400
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: John Kacur <jkacur@redhat.com>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0910072129070.15183@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
	 <1254942848.15477.16.camel@quadrophenia.thebigcorporation.com>
	 <alpine.LFD.2.00.0910072129070.15183@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 13:00:17 -0700
Message-Id: <1254945617.15477.25.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 21:31 +0200, John Kacur wrote:
> 
> On Wed, 7 Oct 2009, Sven-Thorsten Dietrich wrote:
> 
> > On Wed, 2009-10-07 at 20:19 +0200, John Kacur wrote:
> > > I've been staring at the BKL lock in cpuid_open, and I can't see what it 
> > > is protecting. However, I may have missed something - even something 
> > > obvious, so comments are welcome.
> > 
> > I have been using this patch to first see if the BKL is being used
> > simply as mutex, which would allow easier break-down.
> > 
> > Sven
> > 

> Cool! Seems like an excellent experiment. However this is a separate patch
> from the one initially proposed in this thread. I'm willing to risk just 
> removing it in this case without any intermediary step. However, if anyone 
> points out to me why I'm a knuckle head and missed something obvious - I'll 
> listen. Otherwise, let's use your patch as a separate tactic to kill BKL.
> 

Yes, I meant to send this out as RFC Monday, but got side-tracked with
catch-up work, so you prompted me to just reply to your patch.

I was also looking at the cycle_kernel_lock() call in 
arch/x86/kernel/microcode_core.c, which is not obvious to me.

I converted that to cycle_kernel_mutex() using the patch I sent earlier,
but have not had time to actually boot and test.

In any case, I see bkl accesses all over various driver open() and
ioctl() calls.

I think that a number of these are safe to remove, as I still fail to
understand why its necessary to take BKL during any driver open()
routing.

So if its fine for the cpuid_open() call, then I would assume its ok for
others.

Sven


