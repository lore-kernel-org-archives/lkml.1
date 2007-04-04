Return-Path: <linux-kernel-owner+w=401wt.eu-S2992668AbXDDFx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992668AbXDDFx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992669AbXDDFx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:53:57 -0400
Received: from ozlabs.org ([203.10.76.45]:41072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992668AbXDDFx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:53:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.15726.114059.679277@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 15:53:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <1175663999.2932.8.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<20070404022544.59b022a6@the-village.bc.nu>
	<17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	<1175663999.2932.8.camel@shinybook.infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:

> Why? What's so special about the name 'ttyS'?

It's the name that users of Linux expect built-in serial ports to have.

> > The built-in ports can generally be enumerated early on boot in a
> > stable order, and they should be assigned the low ttySn numbers,
> > regardless of what chip is used to implement them. 
> 
> I don't see why that 'should' be the case. Certainly it _isn't_ the case
> on most supported platforms -- we have separate device numbers, and
> names, for most types of ports. There's only one or two drivers which
> abuse ttySn for anything other than 8250 ports.

It 'should' be the case because that is what is easiest for users and
makes most sense from a user's point of view.

You still haven't given any reason why a user should have to know or
care whether the built-in serial ports on his/her computer are
implemented with a 16C550 chip or a Z85C30 chip or something else.

Now, *maybe* the naming can be fixed up with udev.  I haven't invested
the week of my life that it would take to investigate the twisty maze
of shell scripts that udev seems to involve.

In any case your patch is a user-visible incompatible API change and
will break existing working setups, so it should only be put in after
suitable warning has been given.  Maybe we need a module parameter to
select between the old and new behaviour to ease the transition.

Paul.
