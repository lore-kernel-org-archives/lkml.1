Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYLLJV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYLLJV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbYLLJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:21:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbYLLJVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:21:02 -0500
Date: Fri, 12 Dec 2008 10:20:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: fix assign_irq_vector boot up problem
Message-ID: <20081212092041.GH25106@elte.hu>
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112806.740820000@polaris-admin.engr.sgi.com> <200812121857.55929.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812121857.55929.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 11 December 2008 21:58:07 Mike Travis wrote:
> > Impact: fix boot up problem.
> > 
> > Fix a problem encountered with the Intel SATA-AHCI disk driver
> > right at system startup.  Cpumask_intersects really needs to be
> > a 3-way intersect, and since we need a cpumask_var_t later on,
> > then just use it for the 3-way intersect as well.
> 
> This one looks fine.
> 
> My plan was for Ingo to pull that for-ingo tree into his cpus4096 tree 
> and take the x86 patches from there.  But he hasn't so maybe I should 
> take this chance to fold that patch in?

i have no objections against the bits - just the sparseirq complication 
came in. A lot of effort went into irq/sparseirq's io_apic.c changes and 
cleanup.

So to do this cleanly, i merged those bits into cpus4096 and the 
x86/reboot bits as well - now the plan would be for Mike to send a 
(rebased) series against that base. I tried a plain merge and the 
conflicts in io_apic.c were a horrendous 76 rejects due to the 
irq/sparseirq interaction. Also, some of the commits subjects looked a 
bit raw so this bit of the tree needs to be redone.

(Note that the existing cpumask-base+scheduler bits in cpus4096 are 
golden already and we dont have to touch them in any way, it's just the 
new x86 bits and new cpumask infrastructure bits that look odd or 
clashy.)

	Ingo
