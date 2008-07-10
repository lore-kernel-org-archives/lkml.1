Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYGJHvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYGJHvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYGJHuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:50:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYGJHuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:50:51 -0400
Date: Thu, 10 Jul 2008 09:50:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: akataria@vmware.com, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Message-ID: <20080710075030.GA27361@elte.hu>
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com> <20080709061336.GG9760@elte.hu> <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com> <1215624603.3930.8.camel@alok-dev1> <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com> <20080710072201.GE14377@elte.hu> <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > that would be the tip/xen64 stuff, right? Does this revert:
> >
> > |    Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
> > |
> > |    This reverts commit 033786969d1d1b5af12a32a19d3a760314d05329.
> > |
> > |    Suresh Siddha reported that this broke booting on his 2GB testbox.
> >
> > solve your problems, or are there other problems still?
> 
> still is bisecting it now...

ok. I have no mystery crash on my test-systems.

by the looks of it, your crashes seem to be pagetable related. If it's 
in the tip/xen-64bit branch, my candidates would be:

 0f38c08: x86: use __page_aligned_data/bss
 0337869: x86_64: there's no need to preallocate level1_fixmap_pgt
 89d7bb5: x86_64: add workaround for no %gs-based percpu

0337869 is reverted already.

Or if it's an older commit, two candidates would be:

 b50efd2: x86: introduce page_size_mask for 64bit
 3a9e189: x86: map UV chipset space - pagetable

do you know the sha1 of the first broken tree? We know that 
tip-history-2008-07-08_16.08_Tue is known-good.

	Ingo
