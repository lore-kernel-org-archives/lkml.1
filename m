Return-Path: <linux-kernel-owner+w=401wt.eu-S934411AbXFFBLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbXFFBLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933717AbXFFBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:11:32 -0400
Received: from ozlabs.org ([203.10.76.45]:48568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190AbXFFBLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:11:31 -0400
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20070605170747.256f6631@the-village.bc.nu>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <1181055483.14054.40.camel@localhost.localdomain>
	 <20070605170747.256f6631@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 11:10:58 +1000
Message-Id: <1181092258.14054.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 17:07 +0100, Alan Cox wrote:
> On Wed, 06 Jun 2007 00:58:03 +1000
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > The IDE probe is the slowest part of boot: by suppressing it we cut
> > boot from from 3 seconds to half a second.
> 
> NAK NAK NAK NAK NAK

Hi Alan!

> > AFAICT, the commandline is the easiest way to suppress the probing.
> 
> Gaa ... Rusty surely you have more taste than that.

Indeed, but it got attention 8)

> See include/asm-foo/ide.h
> 
> Add an lguest check to go with the pci check and for the lguest case just
> say "no controllers"

Actually, Jeremy suggested claiming the entire IO space.  That works for
Xen domU too, and makes some amount of sense.

> Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> PCI or ISA bus anyway.

Sure, but the "run the same kernel as guest and host" is a really nice
feature.

> Alternatively make the IDE I/O space return 0xFF and it'll skip them
> anyway.

Hmm, every "in" should be returning 0xFFs, but I still get the delay and
the probing.  Xen domU gets it too.

Thanks!
Rusty.

