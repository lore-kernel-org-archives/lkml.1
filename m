Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYJ2GVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYJ2GVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJ2GVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:21:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYJ2GVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:21:12 -0400
Date: Wed, 29 Oct 2008 07:21:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] headers: reduction in interrupt.h
Message-ID: <20081029062100.GB7936@elte.hu>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain> <20081029044524.GC2304@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029044524.GC2304@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> >From 2255be0a5f55ffd58b0ebdf456cf77b7258889fe Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Wed, 29 Oct 2008 06:41:45 +0300
> Subject: [PATCH 2/2] headers: reduction in interrupt.h
> 
> 1. remove sched.h from interrupt.h, it's not needed for anything
> 2. remove sched.h from smp_lock.h, so (1) won't be a lie due to
> 
> 	linux/interrupt.h => linux/hardirq.h => linux/smp_lock.h => linux/sched.h
> 
>    After static inline reacquire_kernel_lock() was moved from there, inclusion
>    isn't needed.
> 3. remove also kernel.h, linkage.h, preempt.h, smp.h, asm/ptrace.h inclusions,
>    I manually checked every token.
> 4. fix fallout
> 
> The end result is that, e.g. i386 allyesconfig kernel shrinks (with all those
> bloated debuginfo sections) from 604.1 MB to 593.1 MB (-1.8 %).
> 
> Compile time should also improve simply because compiler will parse less.
> 
> Cross-compile tested on 469 configs, big and small, across many arches
> and a dozen of randconfigs.

very nice! Regarding my previous mail, we can move the BKL interfaces 
away from sched.c in another patch, i dont want this very cool header 
cleanup be held up.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
