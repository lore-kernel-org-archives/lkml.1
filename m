Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbXJ2PvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbXJ2PvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXJ2PvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:51:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37486 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbXJ2PvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:51:04 -0400
Date: Mon, 29 Oct 2007 15:50:43 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071029155042.GA22406@flint.arm.linux.org.uk>
Mail-Followup-To: Kyle McMartin <kyle@mcmartin.ca>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071028201549.GA23138@fattire.cabal.ca> <20071029081010.GA32160@flint.arm.linux.org.uk> <20071029152152.GD23138@fattire.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029152152.GD23138@fattire.cabal.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 11:21:52AM -0400, Kyle McMartin wrote:
> On Mon, Oct 29, 2007 at 08:10:10AM +0000, Russell King wrote:
> > May I suggest trying:
> > 
> > $ grep RESOURCES_64BIT=y arch/*/configs/* arch/*/defconfig
> > 
> > to locate those architectures which use this?
> > 
> > FYI, that grep says ARM, ia64, mips, parisc, powerpc, PPC, s390, sparc64,
> > and x86 use this feature.
> > 
> 
> It would be nice if the people who actually needed it would have
> select-ed it. That's how I built the list.
> 
> Most of the other examples you listed are obviously 64bit... there should be
> more occurances, but I guess they've (alpha, for instance) not updated
> their defconfig in a dogs age.
> 
> Anyway, sorry I didn't notice ARM. I'll add it to the list on the next
> round.
> 
> Regards,
> 	Kyle
> (but seriously, this should be select-ed, not just set in a defconfig
>  somewhere...)

No.  On ARM it depends on the configuration.  It's not an architectural
thing.  For example, someone might decide to stuff a PCI bus with 64 bit
addressing onto an ARM CPU.  Anyone without that definitely does not want
64 bit resources.

Some ARM systems with PCI busses, the PCI is added via means of an
external chip.  You can't predict whether any particular SoC will have
a PCI bus, or whether it'll be 32-bit or 64-bit.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
