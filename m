Return-Path: <linux-kernel-owner+w=401wt.eu-S936083AbXFGUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936083AbXFGUN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbXFGUNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:13:11 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:32825 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761368AbXFGUNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:13:10 -0400
Date: Thu, 7 Jun 2007 16:13:08 -0400
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Tom Moore <tmoore@spatial.ca>, linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
Message-ID: <20070607201308.GC10006@csclub.uwaterloo.ca>
References: <46642C60.209@spatial.ca> <20070604191052.GD10008@csclub.uwaterloo.ca> <46646B4C.2070707@spatial.ca> <20070605185721.GW10006@csclub.uwaterloo.ca> <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 02:48:50AM +0530, Satyam Sharma wrote:
> Ugh, no! How can we expect the user compiling a kernel to be *so*
> familiar with address space re-mapping / BIOSen (_his_ particular
> BIOS, specifically, and what / how it re-maps memory) / etc to be
> able to answer such questions? "Select ... if you have ... RAM
> installed" is perfectly clear, simple, and all that's needed.
> 
> BTW, just imagine what a user would need to do to make things
> work as per your proposal. Build some kernel (don't care about
> memory loss), boot and find what his firmware prefers to do with
> address space (or else read up the BIOS documentation!) and
> _then_ again build a new kernel, this time selecting the options
> appropriately ...
> 
> Also, note that the change you're proposing is unnecessary! As
> Andi pointed out, this issue has more to do with broken BIOSen
> and the proper fix for Tom is to contact his vendor and flash /
> upgrade the BIOS firmware. I don't see anything wrong with the
> Kconfig help texts.

Well no.  If you have 4GB of ram, and a proper BIOS, then you NEED a
kernel configured for 64GB ram since PCI will take at least 0.5GB of it
and make it remapped above the 4GB address.  So describing the
CONFIG_4GB option as being correct for people with 1 to 4GB ram is very
much wrong for almost all systems.  It would only be correct for those
systems where the bios or chipset incorrectly does not remap memory
above the PCI address space.  The current description is in fact wrong
when the bios isn't broken.  Somewhere around 3 or 3.5GB seems to be the
limit for the CONFIG_4GB option.  Any more and you need the CONFIG_64GB
option instead, unless your bios and/or chipset sucks in which case you
simply loose the ram in the PCI space and you might as well stick with
the CONFIG_4GB option to keep full performance.

--
Len Sorensen
