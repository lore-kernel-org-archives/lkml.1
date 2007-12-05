Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXLEXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXLEXsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLEXsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:48:30 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:26941 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLEXs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:48:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CeKEhq3QUyHx/rCEDT2iFuTX9DJgZsUwOiu0jYQPUeyRZkqp88uYVdTQO8rIGeUC1BVVszvS0A7ZyNFF40QcXjnOCBJnCtqYt+z3wq6rBgVmUnek62L6Wclk/vpogdGAAOVPctWygPSDMikX5MOFERRJPloebVgZ6hc1qr3kI6M=
Message-ID: <32209efe0712051548n72f60b0eofa130f28701ca77@mail.gmail.com>
Date: Wed, 5 Dec 2007 15:48:28 -0800
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Cc: "Len Brown" <lenb@kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <m1mysovi5k.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711280121.18376.lenb@kernel.org>
	 <32209efe0712050525j486922a9s471f3871e69aedff@mail.gmail.com>
	 <m1mysovi5k.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 5, 2007 3:25 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> "Natalie Protasevich" <protasnb@gmail.com> writes:
>
> > On Nov 27, 2007 10:21 PM, Len Brown <lenb@kernel.org> wrote:
> >>     commit c434b7a6aedfe428ad17cd61b21b125a7b7a29ce
> >>     (x86: avoid wasting IRQs for PCI devices)
> >>     created a concept of "IRQ compression" on i386
> >>     to conserve IRQ numbers on systems with many
> >>     sparsely populated IO APICs.
> >>
> >>     The same scheme was also added to x86_64,
> >>     but later removed when x86_64 recieved an IRQ over-haul
> >>     that made it unnecessary -- including per-CPU
> >>     IRQ vectors that greatly increased the IRQ capacity
> >>     on the machine.
> >>
> >>     i386 has not received the analogous over-haul,
> >>     and thus a previous attempt to delete IRQ compression
> >>     from i386 was rejected on the theory that there may
> >>     exist machines that actually need it.  The fact is
> >>     that the author of IRQ compression patch was unable
> >>     to confirm the actual existence of such a system.
> >
> > Those systems did exist (and still exist actually). They used over 200
> > irqs sometimes and with "normal" IRQ allocation they were failing even
> > before reaching half of their I/O configuration. So simple removal
> > wouldn't work for those, dynamic allocation sure would. They "scrolled
> > off the topic" though because new generations of such machines are not
> > 32 bit anymore. So the author didn't actually object :) it was the
> > other users of large 32 bit platforms that did.
>
> Natalie.  Did they just have over 200 irqs/gsis or did they actually
> use over 200 irqs?
>

I think we counted them in the order of 1400 external IRQs (actual
ioapics/slots plus possible on-card bridges), and yes numbers for used
IRQs were close to 250. Actual customer configurations could've big
bigger, I don't have such data.

> In particular is a large NR_IRQS plus dynamic vector allocation
> sufficient for all cases you know about?

Yes, since x86_64 boxes never had a problem once dynamic vectors were
incorporated.

>
> Eric
>
