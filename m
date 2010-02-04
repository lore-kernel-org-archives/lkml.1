Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0BDR7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:59:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756472Ab0BDR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:59:49 -0500
Date: Thu, 4 Feb 2010 09:58:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH] enhanced reimplemention of the kfifo API
Message-Id: <20100204095818.0d854a86.akpm@linux-foundation.org>
In-Reply-To: <1265302360.28857.18.camel@wall-e>
References: <1264597243.3607.24.camel@wall-e>
	<20100203120504.6da9b000.akpm@linux-foundation.org>
	<1265234991.24040.46.camel@wall-e>
	<20100203150545.ebb69cad.akpm@linux-foundation.org>
	<1265302360.28857.18.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Feb 2010 17:52:40 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> ...
> > > > > +#define	kfifo_out_locked(fifo, buf, n, lock) \
> > > > > +__kfifo_check( \
> > > > > +({ \
> > > > > +	unsigned long __flags; \
> > > > > +	unsigned int __ret; \
> > > > > +	spin_lock_irqsave(lock, __flags); \
> > > > > +	__ret = kfifo_out(fifo, buf, n); \
> > > > > +	spin_unlock_irqrestore(lock, __flags); \
> > > > > +	__ret; \
> > > > > +}) \
> > > > > +)
> > > > 
> > > > This is poorly named.  Generally "foo_locked" is to be called when the
> > > > caller has already taken the lock.  This identifier inverts that
> > > > convention.
> > > > 
> > > 
> > > This is the same name as the current kfifo API. Renaming it would break
> > > a lot of drivers. But if there is no complain and you insist i will
> > > rename it and fix the current users.
> > 
> > argh, we goofed.
> > 
> > yeah, it'd be nice to fix it sometime, please.  Not urgent.
> > 
> > A good way to fix it would be to add a new function with a new name
> > then migrate all callers over to that name then when it's done, remove
> > the old name.
> > 
> 
> I will do this in the next release. Would be kfifo_out_spinlocked() and
> kfifo_in_spinlocked() for the new names okay?

Good enough.  It's a bit sad to needlessly expose the type of lock in
the identifier but not the end of the world.

> 
> One offer to solve the egg and chicken problem: Let us include the
> functions kfifo_to_user(), kfifo_from_user(),  kfifo_esize(),
> kfifo_recsize() and the dynamic record handling. If there will be no
> users in at least 9 months we remove it from the API. We talk here about
> 400 bytes of code.
> 
> In the mean time me and other developer will have a change to modify the
> existing driver to the new API and/or post drivers or core kernel code
> which is using this functionality. 
> 

Sounds OK to me.
