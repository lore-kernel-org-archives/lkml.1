Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218Ab0AFT7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0AFT7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195Ab0AFT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:59:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38958 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab0AFT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:59:39 -0500
Date: Wed, 6 Jan 2010 19:59:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/3] generic sys_ipc wrapper
Message-ID: <20100106195905.GE1728@n2100.arm.linux.org.uk>
References: <20100106172152.GC17163@lst.de> <201001062052.11641.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001062052.11641.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 08:52:11PM +0100, Arnd Bergmann wrote:
> > +		switch (version) {

Open of first

> > +		default: {

Open of second

> > +			ulong raddr;
> > +			ret = do_shmat(first, (char __user *)ptr,
> > +				       second, &raddr);
> > +			if (ret)
> > +				return ret;
> > +			return put_user(raddr, (ulong __user *) third);
> > +		}

close of second

> > +
> > +#if defined(__i386__) || defined(__frv__) || defined(__mips__) ||\
> > +    defined(__mn10300__)
> > +		case 1:
> > +			/* iBCS2 emulator entry point */
> > +			if (!segment_eq(get_fs(), get_ds()))
> > +				return -EINVAL;
> > +			/*
> > +			 * The "(ulong *) third" is valid _only_ because of
> > +			 * the kernel segment thing.
> > +			 */
> > +			return do_shmat(first, (char __user *) ptr, second,
> > +					(unsigned long *)third);
> > +#endif
> > +#if defined(__arm__) || defined(__sparc__)
> > +		case 1:
> > +			/* Of course, we don't support iBCS2! */
> > +			return -EINVAL;
> > +#endif
> > +		}

close of first.

> This would not build on any of the architecture mentioned, because of
> incorrect placement of curly braces, but as Al mentioned it should just
> go away entirely.

They look fine to me.

In any case, all three patches get my ack.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
