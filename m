Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255Ab0AWFRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab0AWFRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 00:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806Ab0AWFRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 00:17:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0AWFRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 00:17:37 -0500
Date: Sat, 23 Jan 2010 06:17:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-tip-commits@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100123051717.GA26471@elte.hu>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:

> Commit-ID:  f91c4d2649531cc36e10c6bc0f92d0f99116b209
> Gitweb:     http://git.kernel.org/tip/f91c4d2649531cc36e10c6bc0f92d0f99116b209
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Thu, 21 Jan 2010 18:31:54 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 21 Jan 2010 18:31:54 -0800
> 
> x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
> 
> cpu_specific_poll is a global variable, and it should have a global
> namespace name.  Since it is MCE-specific (it takes a struct mce *),
> rename it mce_cpu_specific_poll.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> LKML-Reference: <20100121221711.GA8242@basil.fritz.box>

FYI, this commit triggered a -tip test failure:

 arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c: In function 'xeon75xx_mce_init':
 arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c:340: error: implicit declaration of function 'pci_match_id'

I'm excluding it from tip:master.

But the bigger problem with this commit is structure of it - or the lack 
thereof.

It just blindly goes into the direction the MCE code has been going for some 
time, minimally enabling the hardware, ignoring both the new EDAC design and 
the new performance monitoring related design i outlined some time ago.

Newly introduced MCE code in the x86 tree should be integrated much better 
into existing higher level facilities, not just limp along ignoring life 
outside of its little box. This will have to be addressed before we can 
reintroduce this commit, even if this trivial build failure is addressed.

I've Cc:-ed a few more interested parties.

Thanks,

	Ingo
