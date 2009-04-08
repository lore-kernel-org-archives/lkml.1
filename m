Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbZDHN0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbZDHN0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764963AbZDHN0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:26:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954AbZDHN0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:26:19 -0400
Date: Wed, 8 Apr 2009 15:25:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler
Message-ID: <20090408132558.GA1141@elte.hu>
References: <20090403185729.GC12273@localhost> <20090408130217.GL18581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090408130217.GL18581@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > For X86-32 if IRQ has no handler it remains non-Ack'ed
> > even if APIC is not requested for being disabled.
> > Fix it.
> 
> nice fix. Did you observe any real hangs in such a situation, or is 
> this via code review?

more stuff needs fixing here first:

arch/x86/kernel/irq.c: In function ‘do_IRQ’:
arch/x86/kernel/irq.c:226: error: ‘disable_apic’ undeclared (first use in this function)
arch/x86/kernel/irq.c:226: error: (Each undeclared identifier is reported only once
arch/x86/kernel/irq.c:226: error: for each function it appears in.)

like making 'disable_apic' available everywhere.

Or better yet: introduce a dummy apic->write() method in the 
disable_apic=1 case so we can call a straight ack_APIC_irq().

	Ingo
