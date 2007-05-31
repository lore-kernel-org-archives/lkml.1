Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXEaNfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXEaNfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXEaNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:34:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXEaNey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:34:54 -0400
Date: Thu, 31 May 2007 15:34:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       asit.k.mallick@intel.com, keith.packard@intel.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64 irq: check remote IRR bit before migrating level triggered irq (v2)
Message-ID: <20070531133426.GA30616@elte.hu>
References: <20070517230324.GB8089@linux-os.sc.intel.com> <m1d50h5irm.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d50h5irm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


looks good to me:

  Acked-by: Ingo Molnar <mingo@elte.hu>

with a few minor style nits:

> +static int io_apic_level_ack_pending(unsigned int irq)
> +{
> +	struct irq_pin_list *entry;
> +	unsigned long flags;
> +	int pending = 0;
> +	spin_lock_irqsave(&ioapic_lock, flags);

newline after variable sections please.

> +	entry = irq_2_pin + irq;
> +	for (;;) {
> +		unsigned int reg;
> +		int pin;
> +		pin = entry->pin;

ditto.

> +		if (pin == -1)
> +			break;
> +		reg = io_apic_read(entry->apic, 0x10 + pin*2);
> +		/* Is the remote IRR bit set? */
> +		pending |= (reg >> 14) & 1;
> +		if (!entry->next)
> +			break;
> +		entry = irq_2_pin + entry->next;
> +	}
> +	spin_unlock_irqrestore(&ioapic_lock, flags);
> +	return pending;

optional: it looks a bit better with a newline before the 'return' 
statement.

> +}
> +
> +

and here there's one too much newline :-)

	Ingo
