Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbXHBAHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbXHBAHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXHBAHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:07:32 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39651 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbXHBAHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:07:31 -0400
Date: Thu, 2 Aug 2007 02:06:27 +0200 (MEST)
Message-Id: <200708020006.l7206RoY009376@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: buytenh@wantstofly.org, mikpe@it.uu.se
Subject: Re: [PATCH][RFC] unbreak generic futex_atomic_cmpxchg_inatomic() on UP
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rmk@arm.linux.org.uk,
       tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 01:49:02 +0200, Lennert Buytenhek wrote:
> On Thu, Aug 02, 2007 at 01:00:21AM +0200, Mikael Pettersson wrote:
> 
> > @@ -52,7 +53,34 @@ futex_atomic_op_inuser (int encoded_op, 
> >  static inline int
> >  futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> >  {
> > +#ifdef CONFIG_SMP
> >  	return -ENOSYS;
> > +#else
> 
> Since the callers of futex_atomic_cmpxchg_inatomic() don't really
> seem prepared to deal with -ENOSYS (e.g. the handle_futex_death()
> infinite loop when it gets -ENOSYS), it seems better never to
> return -ENOSYS from this function at all.
> 
> What if you just stick an #error in here in the SMP case?

The problem with #error is that it would cause compile-time
regressions. I assume that e.g. alpha supports building SMP
kernels, but #error would prevent that.

Thus I opted to fix the UP case while leaving the SMP case
unchanged. Actually I think the SMP case should be a BUG()
rather than -ENOSYS, but that's a different issue from the
UP case which I really do want to see fixed.

/Mikael
