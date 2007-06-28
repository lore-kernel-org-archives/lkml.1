Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbXF1XCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbXF1XCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbXF1XCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:02:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbXF1XCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:02:13 -0400
Date: Thu, 28 Jun 2007 16:01:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-Id: <20070628160152.3f36af82.akpm@linux-foundation.org>
In-Reply-To: <20070628224511.GA12447@c2.user-mode-linux.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
	<20070628110644.a530cfef.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282017450.30789@anakin>
	<20070628113819.c24e592d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282044360.30789@anakin>
	<20070628132947.e3378811.akpm@linux-foundation.org>
	<20070628232537.02ced21c@the-village.bc.nu>
	<20070628224511.GA12447@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 18:45:11 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Thu, Jun 28, 2007 at 11:25:37PM +0100, Alan Cox wrote:
> > This completely bogus. readb() should be present on M68K, fix the
> > platform to implement readb() for MMIO, even if your MMIO readb is a
> > moveb instruction.
> > 
> > check_signature is relevant for anything with MMIO space (for example you
> > can legitimately want to check_signature a MAC68K Nubus ROM).
> > 
> > S/390 is a bit of a special case as no S/390 usage of check_signature
> > appears sane but equally it isn't used so you can stub it out.
> 
> This is a problem for UML too.
> 
> I have a patch in my tree, which basically stubs readb, waiting to see
> how this is fixed for the other arches.
> 

What a mess.

I guess we could add an empty readb() implementation to lib/lib.a so the
arch will pick that up if all else fails.  But it's pretty stinky.  And
it won't work either because we don't know at compile-time to declare
the prototype for that thing appropriately.

So... what's the proper fix here?  "The arch must implement readb"?  That's
bad: if the arch really cannot implement readb(), we want builds to fail
if someone tries to use it.

I think I'll go shopping instead.
