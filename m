Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbXHBA6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbXHBA6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXHBA6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:58:35 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:46072 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXHBA6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:58:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=kgHVySgIjzMgDh0JRB6BXutl7mOosQhYnKtSY0LfbIHMK1ghoPdCYmFR8htgn
	tHM4kjUzYhYHVqw+E/EONYBhg==
Date: Thu, 2 Aug 2007 02:58:22 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rmk@arm.linux.org.uk,
       tglx@linutronix.de
Subject: Re: [PATCH][RFC] unbreak generic futex_atomic_cmpxchg_inatomic() on UP
Message-ID: <20070802005822.GB7910@xi.wantstofly.org>
References: <200708020006.l7206RoY009376@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708020006.l7206RoY009376@harpo.it.uu.se>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:06:27AM +0200, Mikael Pettersson wrote:

> > > @@ -52,7 +53,34 @@ futex_atomic_op_inuser (int encoded_op, 
> > >  static inline int
> > >  futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> > >  {
> > > +#ifdef CONFIG_SMP
> > >  	return -ENOSYS;
> > > +#else
> > 
> > Since the callers of futex_atomic_cmpxchg_inatomic() don't really
> > seem prepared to deal with -ENOSYS (e.g. the handle_futex_death()
> > infinite loop when it gets -ENOSYS), it seems better never to
> > return -ENOSYS from this function at all.
> > 
> > What if you just stick an #error in here in the SMP case?
> 
> The problem with #error is that it would cause compile-time
> regressions. I assume that e.g. alpha supports building SMP
> kernels, but #error would prevent that.
> 
> Thus I opted to fix the UP case while leaving the SMP case
> unchanged. Actually I think the SMP case should be a BUG()
> rather than -ENOSYS,

Probably.  Or handle -ENOSYS in the callers -- but that's more
work, and would cease to be necessary once everyone implements
futex_atomic_cmpxchg_inatomic().


> but that's a different issue from the UP case which I really do
> want to see fixed.

ACK.
