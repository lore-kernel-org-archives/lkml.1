Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYGaVik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYGaVik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYGaVic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:38:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbYGaVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:38:31 -0400
Date: Thu, 31 Jul 2008 23:37:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, a.p.zijlstra@chello.nl,
       vatsa@linux.vnet.ibm.com, efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks
	PXA270 (at least)?
Message-ID: <20080731213741.GJ2729@elte.hu>
References: <20080729223105.GK10982@flint.arm.linux.org.uk> <20080729154605.d540cf6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729154605.d540cf6d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Jul 2008 23:31:05 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > But then some bright spark thought it would be a good idea to get
> > rid of printk_clock().
> 
> <does git-log, searches for printk_clock>

i think this is a fresh regression via the introduction of 
kernel/sched_clock.c. We lost the (known) early-init behavior of 
cpu_clock() in the !UNSTABLE_SCHED_CLOCK case. The fix would be to 
restore that, not to reintroduce printk_clock().

Peter, any ideas?

	Ingo
