Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZBNXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZBNXaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbZBNXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:22:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759376AbZBNXWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:22:46 -0500
Date: Sun, 15 Feb 2009 00:22:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       srostedt@redhat.com
Subject: Re: irqflags.h changes
Message-ID: <20090214232217.GF20477@elte.hu>
References: <20090214002324.GA22590@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214002324.GA22590@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Currently, linux/irqflags.h defines local_irq_enable() and friends
> through raw_* counterparts.
> 
> Sometimes it defines raw_* counterparts through local_irq_enable() and
> friends.
> 
> I'm going to end this subtle joke and make on all archs:
> 
> 	local_irq_enable()	via	raw_local_irq_enable()
> 	local_irq_disable()	via	raw_local_irq_disable()
> 	local_irq_save()	via	raw_local_irq_save()
> 	local_irq_restore()	via	raw_local_irq_restore() + stuff
> 	local_save_flags()	via	raw_local_save_flags()
> 	irqs_disabled()		via	raw_irqs_disabled_flags() + stuff
> 
> linux/irqflags.h will include asm/irqflags.h unconditionally.
> Arches that don't have asm/irqflags.h will get it through extraction
> from asm/system.h or whatever.
> 
> Users will just include <linux/irqflags.h>
> 
> Irq tracing will remain the same (it's nop depending on config option,
> after all).
> 
> Typechecking will be preserved.
> 
> Compilation will be fixed.
> 
> And possibly changing some defines into static inlines.
> 
> OK?

This is a much welcome cleanup!

Since if this causes a regression anywhere that's going to be lockdep,
can we pick this up into the locking tree - or would you like to carry
it in a separate tree? (the procfs tree isnt appropriate for it i guess)

	Ingo
