Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXCBVlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXCBVlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030462AbXCBVlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:41:51 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:62234 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXCBVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:48 -0500
Date: Fri, 2 Mar 2007 22:39:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070302213959.GA9514@osiris.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com> <20070302125848.GA8226@osiris.boeblingen.de.ibm.com> <20070302130433.GA4391@elte.hu> <20070302142308.GB8226@osiris.boeblingen.de.ibm.com> <20070302084833.732d09dd.akpm@linux-foundation.org> <20070302190836.GA7942@osiris.ibm.com> <20070302114524.1c61cf22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302114524.1c61cf22.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/*
> > + * double_timer_lock/unlock are used to ensure that on cpu hotplug the
> > + * per cpu timer locks are always taken in the same order.
> > + */
> > +static void __devinit double_timer_lock(tvec_base_t *base1,
> > +					tvec_base_t *base2, int ind)
> > +	__acquires(base1->lock)
> > +	__acquires(base2->lock)
> 
> hm.  Can we not just pass in the spinlock_t*'s and use a common function?
> 
> 	void double_spin_lock(spinlock_t *l1, spinlock_t *l2, int ind);
> 
> that way it has nothing to do with timers and can potentially be used
> elsewhere in the kernel, too.
> 
> (what does "ind" mean?)

Sure. Will put a static inline function into include/linux/spinlock.h.
"ind" is supposed to be the short form of "indicator".
