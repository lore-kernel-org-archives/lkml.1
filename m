Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXEKSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXEKSxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXEKSxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:53:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45567 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbXEKSxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:53:37 -0400
Date: Fri, 11 May 2007 20:54:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070511185431.GA31719@uranus.ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510205427.GF29713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 09:54:27PM +0100, Russell King wrote:
> On Thu, May 10, 2007 at 01:51:47PM -0700, David Miller wrote:
> > From: Chris Wedgwood <cw@f00f.org>
> > Date: Thu, 10 May 2007 13:34:18 -0700
> > 
> > > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > > to fix it so perhaps we should silence it for now?
> > 
> > Most of them are legitimate, the only one that needs sorting
> > is the mm/slab.c case and people are working on that.
> > 
> > The rest are useful and I've been working to fix things up
> > on sparc64 and the networking, and in fact I'm very happy
> > about these notifications.
> > 
> > Please don't apply a sledgehammer to this issue, thanks.
> 
> I've not had one accurate one on ARM yet.

To be able to test my modpost changes I am building arm for all configs.
I can see a number of legitime warnings for the ARM code.
Those I have investigated has all been of the case where functions
are used only during init but not marked init.
So no real bugs just potential savings and consistency.
Shall I try to fix them up and drop you a path?

Samples (with old warning format):

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pcmcia_assabet_init from .text between 'sa11x0_drv_pcmcia_probe' (at offset 0x49ed8) an
d 'assabet_pcmcia_socket_state'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pcmcia_collie_init from .text between 'sa11x0_drv_pcmcia_probe' (at offset 0x5f250) and
 'sharpsl_pcmcia_init_reset'
WARNING: drivers/pcmcia/sa1100_cs.o - Section mismatch: reference to .init.text:pcmcia_cerf_init from .text between 'sa11x0_drv_pcmcia_probe' (at offset 0xc) a
nd 'cerf_pcmcia_socket_state'

WARNING: arch/arm/mach-at91/built-in.o - Section mismatch: reference to .init.data: from .text after 'nand_partitions' (at offset 0xbdc)
WARNING: arch/arm/mach-at91/built-in.o - Section mismatch: reference to .init.data: from .text between 'nand_partitions' (at offset 0xbdc) and 'ads7843_pendown
_state'
WARNING: arch/arm/mach-at91/built-in.o - Section mismatch: reference to .init.data: from .text between 'nand_partitions' (at offset 0xdf4) and 'at91_leds_event
'


	Sam
