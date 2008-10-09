Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYJIM0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYJIM0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbYJIM0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:26:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbYJIM0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:26:06 -0400
Date: Thu, 9 Oct 2008 14:25:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: use spin_lock_nest_lock when pinning a pagetable
Message-ID: <20081009122549.GA2952@elte.hu>
References: <48ED11A3.3090605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED11A3.3090605@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When pinning/unpinning a pagetable with split pte locks, we can end up
> holding multiple pte locks at once (we need to hold the locks while
> there's a pending batched hypercall affecting the pte page).  Because
> all the pte locks are in the same lock class, lockdep thinks that
> we're potentially taking a lock recursively.
>
> This warning is spurious because we always take the pte locks while
> holding mm->page_table_lock.  lockdep now has spin_lock_nest_lock to
> express this kind of dominant lock use, so use it here so that lockdep
> knows what's going on.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/mmu.c |   74 +++++++++++++++++++++++++++++++++-------------------
> arch/x86/xen/mmu.h |    3 --
> 2 files changed, 48 insertions(+), 29 deletions(-)

applied to tip/x86/xen, thanks Jeremy!

	Ingo
