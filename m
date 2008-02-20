Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbYBTUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbYBTUkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYBTUjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:39:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:46693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbYBTUjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:39:46 -0500
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign
	endianness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Koller <clemens.koller@anagramm.de>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <20080220121818.GA20836@localhost.localdomain>
References: <20080214224942.a0cb6218.akpm@linux-foundation.org>
	 <20080215164542.GB16810@localhost.localdomain>
	 <Pine.LNX.4.64.0802171030330.6848@anakin>
	 <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
	 <19805.1203355811@turing-police.cc.vt.edu> <47BA162C.5000807@anagramm.de>
	 <1203381353.6740.59.camel@pasglop> <47BABD3A.7010102@anagramm.de>
	 <20080219040530.7b1d115d.akpm@linux-foundation.org>
	 <18363.31427.989835.105966@cargo.ozlabs.ibm.com>
	 <20080220121818.GA20836@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 07:38:40 +1100
Message-Id: <1203539920.10422.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 15:18 +0300, Anton Vorontsov wrote:
> On Wed, Feb 20, 2008 at 11:56:35AM +1100, Paul Mackerras wrote:
> > Andrew Morton writes:
> > 
> > > Bizarrely, the original author of the patch (Anton) has fallen off the cc. 
> > > Could whoever did that please thwap himself?
> > > 
> > > Anyway, my head is now officially spinning.  Did anyone actually have a
> > > reason why we shouldn't proceed with Anton's patch?
> > 
> > I was wondering if it would be sufficient to provide alternative
> > versions of fb_readl, fb_writel etc. that do byte-swapping.
> 
> This is of course viable alternative. And I was considering this, but
> later I abandoned the idea: that way we'll end up doing math in the
> native endianness and then converting it to the foreign. This feels
> ugly in contrast when we can do the right math in the first place, per
> framebuffer.

Also, the type of swap to do in fb_readl/writel would have to depend
on the bit depth which is kind of ugly.

> > That
> > would mean that all framebuffers would have to have the same
> > endianness,
> 
> Yup, another downside of changing the code to fix some narrow
> problem. Plus, this means things will break if/when we'll attach
> PCI video card into the MPC8360E-RDK.

Right.

Ben.

