Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHVFRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHVFRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYHVFRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:17:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYHVFRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:17:15 -0400
Date: Fri, 22 Aug 2008 07:16:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>, Alan Mayer <ajm@sgi.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Message-ID: <20080822051656.GA7696@elte.hu>
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com> <48ADFB33.8010204@goop.org> <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com> <48ADFFD2.7030309@goop.org> <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com> <48AE022F.6030100@goop.org> <20080822042610.GA15212@elte.hu> <86802c440808212206s66c31203n651ca021c01104ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808212206s66c31203n651ca021c01104ca@mail.gmail.com>
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

> > But by all means SPARSEIRQ is the primary and only model on x86.
> >
> > We could even plug in the dynamic vector allocator from Alan Mayer 
> > now, both on 32-bit and on 64-bit x86: Yinghai, any complications 
> > expected there? I guess we need to unify the local APIC code first.
> 
> apic_32.c and apic_64.c
> irqinit_32.c and irqinit_64.c
> irq_32.c and irq_64.c
> 
> Cyrill, is still working on merging apic_32.c apic_64.c.?

there's a few weeks of inactivity expected in that area i think - so if 
you'd like to pick it up from there, feel free ...

but apic_32/64.c is looking already pretty good in tip/master:

 1 file changed, 391 insertions(+), 358 deletions(-)

the most significant bit of that delta seems to be around x2apic, 
calibration differences and some older 32-bit legacies which are not on 
the 64-bit side (but which we can add safely).

	Ingo
