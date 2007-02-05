Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXBEQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXBEQqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXBEQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:46:23 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4187 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXBEQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:46:22 -0500
Date: Mon, 5 Feb 2007 16:46:04 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205164603.GC4563@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205162635.GA755@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:26:35PM +0100, Ingo Molnar wrote:
> we should not have 'select' at all - unless it's some non-code option 
> that is just a convenience switch for several other config options. A 
> true dependency is already expressed in one direction via the 'depend 
> on' directive - no need to express it in the other direction as well, 
> that only leads to redundancy and to bugs.

I disagree.  There's a valid use for select.

config PCI
	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX
	default y if ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || \
		ARCH_IXP2000 || ARCH_IXP23XX || ARCH_SHARK || \
		ARCH_CATS || ARCH_PERSONAL_SERVER || ARCH_EBSA285_HOST || \
		ARCH_NETWINDER || MACH_NSLU2 || MACH_AVILA || \
		ARCH_ADI_COYOTE || MACH_NAS100D || MACH_GTWX5715
	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || \
		ARCH_IXP2000 || ARCH_IXP23XX || ARCH_SHARK || \
		ARCH_CATS || ARCH_PERSONAL_SERVER || ARCH_EBSA285_HOST || \
		ARCH_NETWINDER || MACH_NSLU2 || MACH_AVILA || \
		ARCH_ADI_COYOTE || MACH_NAS100D || MACH_GTWX5715 || \
		ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX

where (ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX) can not be
are mutually exclusive with the remaining group

vs:

config PCI
	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX

and the rest (ie, except integrator, versatile and ixp4xx) has:

config ARCH_SHARK
        bool "Shark"
        select PCI

IOW, the "PCI support" question isn't offered for platforms which require
PCI to be present, but is offered on platforms where it's optional.

To you, which looks more maintainable?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
