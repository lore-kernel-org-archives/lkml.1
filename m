Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbXLEX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbXLEX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLEX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:27:16 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42382 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLEX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:27:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Natalie Protasevich" <protasnb@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
	<32209efe0712050525j486922a9s471f3871e69aedff@mail.gmail.com>
Date: Wed, 05 Dec 2007 16:25:11 -0700
In-Reply-To: <32209efe0712050525j486922a9s471f3871e69aedff@mail.gmail.com>
	(Natalie Protasevich's message of "Wed, 5 Dec 2007 05:25:54 -0800")
Message-ID: <m1mysovi5k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Natalie Protasevich" <protasnb@gmail.com> writes:

> On Nov 27, 2007 10:21 PM, Len Brown <lenb@kernel.org> wrote:
>>     commit c434b7a6aedfe428ad17cd61b21b125a7b7a29ce
>>     (x86: avoid wasting IRQs for PCI devices)
>>     created a concept of "IRQ compression" on i386
>>     to conserve IRQ numbers on systems with many
>>     sparsely populated IO APICs.
>>
>>     The same scheme was also added to x86_64,
>>     but later removed when x86_64 recieved an IRQ over-haul
>>     that made it unnecessary -- including per-CPU
>>     IRQ vectors that greatly increased the IRQ capacity
>>     on the machine.
>>
>>     i386 has not received the analogous over-haul,
>>     and thus a previous attempt to delete IRQ compression
>>     from i386 was rejected on the theory that there may
>>     exist machines that actually need it.  The fact is
>>     that the author of IRQ compression patch was unable
>>     to confirm the actual existence of such a system.
>
> Those systems did exist (and still exist actually). They used over 200
> irqs sometimes and with "normal" IRQ allocation they were failing even
> before reaching half of their I/O configuration. So simple removal
> wouldn't work for those, dynamic allocation sure would. They "scrolled
> off the topic" though because new generations of such machines are not
> 32 bit anymore. So the author didn't actually object :) it was the
> other users of large 32 bit platforms that did.

Natalie.  Did they just have over 200 irqs/gsis or did they actually
use over 200 irqs?

In particular is a large NR_IRQS plus dynamic vector allocation
sufficient for all cases you know about?

Eric
