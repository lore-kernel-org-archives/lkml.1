Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZFIWgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZFIWgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZFIWgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:36:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:47518 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZFIWgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:36:42 -0400
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
 [drivers/staging/comedi/drivers.o]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: subrata@linux.vnet.ibm.com
Cc: Greg KH <greg@kroah.com>, fmhess@users.sourceforge.net,
       Ian Abbott <abbotti@mev.co.uk>, David Miller <davem@davemloft.net>,
       sachinp@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       Geert.Uytterhoeven@sonycom.com, geert@linux-m68k.org
In-Reply-To: <1244572446.5497.32.camel@subratamodak.linux.ibm.com>
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
	 <1244261806.31984.36.camel@pasglop> <20090606055103.GA9446@kroah.com>
	 <200906060936.22322.fmhess@speakeasy.net>
	 <1244385405.5265.7.camel@subratamodak.linux.ibm.com>
	 <1244519418.5235.2.camel@pasglop>
	 <1244572446.5497.32.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 08:34:39 +1000
Message-Id: <1244586879.24481.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > In any case, doing PAGE_KERNEL_NOCACHE for DMA memory is incorrect on
> > many architectures. So at this stage, there's no much option but ifdef I
> > suspect for now until this is fixed properly.
> 
> Ok. But, i am not sure whether Greg will agree to this. If, Ok, is the
> following patch i sent earlier Ok ?
> 
> http://lkml.org/lkml/2009/6/5/462,

Not really.

You probably want to use a constant (call it MY_DMA_MAP_PGPROT), and
in a header, you have a bunch of ifdef's that set it to PAGE_KERNEL,
PAGE_KERNEL_NOCACHE or PAGE_KERNEL_NC depending on what's needed.

Today, you can pretty much assume that

 - x86*, sparc*, ia64*, alpha, ... needs PAGE_KERNEL
 - powerpc needs PAGE_KERNEL if !CONFIG_NOT_COHERENT_CACHE
 - powerpc needs PAGE_KERNEL_NC if CONFIG_NOT_COHERENT_CACHE
 - ARM and MIPS, I think, needs PAGE_KERNEL_NOCACHE
 - ... others I don't know.

Cheers,
Ben.

> Regards--
> Subrata
> 
> > 
> > It does make sense to want to have some memory like that shared between
> > user space and DMA, though I don't know what the right approach that
> > works on all archs is at this stage. Worth asking the Alsa guys, I think
> > they have similar issues :-)
> > 
> > But doing double buffering might do the trick fine for now.
> > 
> > Cheers,
> > Ben.
> > 
> > 
> > 
> > 

