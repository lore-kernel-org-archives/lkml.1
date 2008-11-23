Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYKWBkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYKWBkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKWBkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:40:31 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:2942 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYKWBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:40:30 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how
 many person-time fight for the ticket spinlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yang Xi <yangxilkm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, chyyuu <chyyuu@gmail.com>
In-Reply-To: <d36bb30d0811200009j742416a6nbc0519ff8d95970b@mail.gmail.com>
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
	 <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
	 <1227112785.29743.37.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811200009j742416a6nbc0519ff8d95970b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 02:40:26 +0100
Message-Id: <1227404426.7685.19975.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 16:09 +0800, Yang Xi wrote:
> > I of course meant folding cpu and isspinlock into a combined bitfield
> > (sorry for not being more clear), thereby saving space, this still takes
> > 2*sizeof(int).
> >
> > We can safely take some bits from the cpu number as there currently are
> > no plans for a 2g cpu machine, right SGI? :-)
> Thanks, ok, 31bits enough for cpu at now stage. 1bit for isticketspinlock.
> Here is the new one. Welcome more comments :).

Looks good, one more question :-)

> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -127,6 +127,12 @@ do {
>                  \
>  #define spin_is_contended(lock)
> __raw_spin_is_contended(&(lock)->raw_lock)
>  #endif
> 
> +#ifdef CONFIG_HAVE_TICKET_SPINLOCK
> +#define spin_nr_contended(lock) __ticket_spin_nr_contended(&(lock)->raw_lock)
> +#else
> +#define spin_nr_contended(lock) (0)
> +#endif
> +

Does it make sense to make the alternative case return
spin_is_contended()?

