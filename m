Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYGNWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYGNWbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYGNWbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:31:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38729 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbYGNWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:31:24 -0400
Date: Mon, 14 Jul 2008 23:30:52 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Message-ID: <20080714223052.GA2469@flint.arm.linux.org.uk>
References: <20080708134242.GA6176@doriath.ww600.siemens.net> <20080708134336.GA6240@doriath.ww600.siemens.net> <20080712234823.e632c7f9.akpm@linux-foundation.org> <200807131412.32961.david-b@pacbell.net> <20080713142317.97111c81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713142317.97111c81.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 02:23:17PM -0700, Andrew Morton wrote:
> On Sun, 13 Jul 2008 14:12:32 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > On Saturday 12 July 2008, Andrew Morton wrote:
> > > > +EXPORT_SYMBOL(clk_get_parent);
> > > 
> > > As this is a new kernel-wide utility library, it is appropriate that
> > > all of its public interfaces (at least) be documented. __An appropriate
> > > way of doing that is via kerneldoc annotation. __Please don't forget to
> > > document return values and call environment prerequisites (eg: requires
> > > foo_lock, may be called from interrupt context, etc, etc).
> > 
> > That is, the stuff that's not already documented in <linux/clk.h>;
> > that's where clk_get_parent() is documented, for example.
> 
> argh.  That's why I missed it - please don't document stuff in header
> files.  The usual approach is to document interfaces at the
> implementation site.

That doesn't work.  In this case, linux/clk.h _is_ the only source of
the API.  The API is just a defined set of functions.

How an architecture or machine class implements it is at the discressiom
of whoever's writing that code.  The point being, that we have a fixed
core API which drivers can use which is portable across different SoCs.

However, there certainly are implementation specific issues which
architecture code needs to know about - hence why the implementation
has (until genclk) been left completely up to that code to decide and
implement the interface.

So, the only place for that documentation is the header file.  Documenting
an implementation will just confuse the issue and lead people into thinking
that it somehow represents the way things should be done.

Even genclk doesn't represent "The Way Things Should Be Done" - it's just
yet another implementation of the interface.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
