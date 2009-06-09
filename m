Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZFIGcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZFIGcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZFIGcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:32:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbZFIGcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:32:14 -0400
Date: Tue, 9 Jun 2009 08:32:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: adding lockdep support to the Blackfin arch
Message-ID: <20090609063208.GA3983@elte.hu>
References: <8bd0f97a0906081628o7d30e05ld961c00a690c140d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906081628o7d30e05ld961c00a690c140d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> ive been extending the Blackfin arch recently to support lockdep.
> since i also had to implement irqflags/stacktrace as well, i wouldnt
> be surprised if this issue is nested in there, plus this is a no-mmu
> system.
> 
> at any rate, when i boot up a Blackfin system with PROVE_LOCKING
> enabled, i end up with this warning:
> Badness at kernel/fork.c:988
> 
> which correlates to this in copy_process():
>     DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);

This suggests that the irqflags tracking might be wrong: the fork 
code expects it at this point that hardirqs are enabled.

> btw, in order to get this to work in the first place, i had to 
> extend

[incomplete mail?]

	Ingo
