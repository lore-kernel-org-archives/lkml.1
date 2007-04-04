Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXDDGb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXDDGb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXDDGb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:31:27 -0400
Received: from ozlabs.org ([203.10.76.45]:37553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbXDDGb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:31:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.17962.248566.886449@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 16:31:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <1175666635.2932.17.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<20070404022544.59b022a6@the-village.bc.nu>
	<17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	<1175663999.2932.8.camel@shinybook.infradead.org>
	<17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	<1175666635.2932.17.camel@shinybook.infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:

> > It 'should' be the case because that is what is easiest for users and
> > makes most sense from a user's point of view.
> 
> I really don't buy that argument. People cope perfectly well
> with /dev/ttySA0 on StrongARM, with /dev/ttySC0 on SH, etc. If it isn't

Those are embedded platforms and therefore don't have users who aren't
developers interacting with it as a general-purpose computer.

> an 8250, it doesn't usually get called ttyS0. There's certainly nothing
> _easier_ about ttyS0. Unless it's really an effort to type that extra
> character :)
> 
> > You still haven't given any reason why a user should have to know or
> > care whether the built-in serial ports on his/her computer are
> > implemented with a 16C550 chip or a Z85C30 chip or something else.
> 
> Because that's the way serial ports are named under Linux.

In other words we're too lame to abstract the hardware properly and
users just have to deal with it...

> > In any case your patch is a user-visible incompatible API change and
> > will break existing working setups, so it should only be put in after
> > suitable warning has been given.  Maybe we need a module parameter to
> > select between the old and new behaviour to ease the transition.
> 
> Perhaps that's true; I'd certainly never seen a working setup with
> pmac_zilog, because I'd never actually seen the module load. It's always
> failed for me, because I have 8250 support built in to my kernels.

You probably don't have a powermac or powerbook that has usable,
externally accessible serial ports either.  Plenty of other people do.

It seems Debian has both 8250 and pmac_zilog built in; not sure which
one wins.  Ubuntu has them both as modules and managed to get the
right one (pmac_zilog) loaded on a colleague's powerbook.  You'd know
better than me what FC does.

In any case there definitely are people using pmac_zilog successfully
on powermacs and we need to come up with a way to avoid breaking their
setups.  I'm prepared to accept that the Linux way is to be lame about
serial port naming provided that we avoid breaking existing working
setups.

Paul.
