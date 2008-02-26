Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYBZJyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYBZJyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYBZJx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:53:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57940 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYBZJx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:53:57 -0500
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080225223338.9602E25E979@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20080225223338.9602E25E979@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 10:53:46 +0100
Message-Id: <1204019626.6242.225.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 14:33 -0800, David Brownell wrote:

> > +#ifdef CONFIG_LOCKDEP
> > +
> > +/* tell lockdep that this IRQ's locks and its parent's locks are in
> > + * different categories, so that it won't detect false recursion.
> > + */
> > +static struct lock_class_key gpio_lock_class;
> > +
> > +static inline void mark_gpio_locking(unsigned gpio_irq)
> > +{
> > +	lockdep_set_class(&irq_desc[gpio_irq].lock, &gpio_lock_class);
> > +}
> > +
> > +#else
> > +
> > +static inline void mark_gpio_locking(unsigned gpio_irq)
> > +{
> > +	/* NOP */
> > +}
> > +
> > +#endif

Glad to hear this works out for you.

Just one note, you don't need the #ifdef mess here. struct
lock_class_key is 0 bytes on !LOCKDEP and lockdep_set_class*() is
defined away as well.


