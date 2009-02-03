Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZBCJ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZBCJ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBCJ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:27:04 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33853 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZBCJ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:27:02 -0500
Date: Tue, 3 Feb 2009 02:27:00 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH F 06/12] OMAP2/3 clock: every clock must have a clkdm
In-Reply-To: <20090131140804.GH1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902030011320.5741@utopia.booyaka.com>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193512.2396.75340.stgit@localhost.localdomain> <20090131140804.GH1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:35:15PM -0700, Paul Walmsley wrote:
> > Every OMAP2/3 clock must now have an assigned clockdomain, so we can
> > remove the checks from clk_enable()/clk_disable().  Instead, verify
> > that the clockdomain is present only at clock init time via the
> > arch_clock clk_register() hook.
> 
> I don't see the point of requiring all clocks to have a clockdomain field.

For physical clocks, the idea is to match the OMAP2/3 hardware, in which 
nearly every clock is associated with a clockdomain.  The point for 
virtual clocks is to discourage the use of virtual clocks.

> Given that we have virtual clocks, it is quite reasonable for some clocks
> not to have a clock domain associated with them.

Virtual clocks should soon be eliminated from the OMAP clock tree.  ( 
"Virtual clocks" is here used to refer a clock that does not have a 
referent in the hardware; the usage of the term in the code is loose.)  
So far as I know, all of the OMAP virtual clocks have either turned out to 
be superfluous (and prone to spinlock recursion bugs), or to be better 
implemented outside of the clock framework (such as the virtual OPP 
clocks).  We've eliminated the former.  We should be able to eliminate the 
latter in a few months.

Only physical hardware clocks will then be left in the clock tree.  For 
OMAP2/3, it makes sense to keep those grouped into clockdomains, since 
that is how they are implemented in the hardware.

So I'd recommend keeping this requirement.


- Paul
