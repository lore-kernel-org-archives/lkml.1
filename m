Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXEFUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXEFUSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXEFUSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:18:54 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:47734 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbXEFUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:18:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=NELGQx/eDeOS3fTD+1mTbc6YsZCqnzw5fTixgd7dH0+b6qfWRmSVAi2hEIT0q
	33pY3QAlrGSfkEpGWIJFONWnQ==
Date: Sun, 6 May 2007 22:18:48 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, "Curt E. Bruns" <curt.e.bruns@intel.com>,
       Peter Milne <peter.milne@d-tacq.com>,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and iop13xx
Message-ID: <20070506201848.GE19339@xi.wantstofly.org>
References: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com> <20070506095256.GA2521@infomag.infomag.iguana.be> <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:13:58PM -0700, Dan Williams wrote:

> >> Here is a new watchdog driver for your review.  It supports two flavors
> >> of the iop watchdog timer.  The iop13xx watchdog can be stopped while
> >> the iop3xx version cannot.
> >
> >I started reviewing this patch yesterday. First thing I noticed was that
> >you seem to be moving some code from include/asm-arm/arch-iop13xx/system.h
> >to include/asm-arm/arch-iop13xx/iop13xx.h .
> >This should not be part of this patch since it is touching architecture
> >dependant code for which I do not have enough knowledge about this specific
> >architecture to tell if this is indeed the correct way to do this.
> >The maintainers of this architecture should imho comment on this.
> >Could you split this patch into 2 patches: one that deals with the moving 
> >of
> >the architecture dependant code (and explaining why) and one with the new
> >watchdog drivers? I will continue my review today.
> 
> I am one of the maintainers of this architecture, (Lennert Buytenhek
> is the other).

Dan has done more work on iop13xx than I have, and I'm OK with his
changes.

It's true that ARM-specific changes generally should go through the ARM
tree, but IMHO sometimes it makes sense to have one patch touch both
stuff under drivers/ and stuff under arch/arm/mach-foo, especially if
the changes are dependent and cause compile breakage if applied
separately.  Not sure whether that's the case here.
