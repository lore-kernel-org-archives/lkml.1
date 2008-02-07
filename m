Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYBGQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYBGQLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYBGQLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:11:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41219 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYBGQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:11:30 -0500
Date: Thu, 7 Feb 2008 16:05:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcin Juszkiewicz <openembedded@haerwu.biz>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207160557.GB28435@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802071609.36960.openembedded@haerwu.biz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 04:09:34PM +0100, Marcin Juszkiewicz wrote:
> Dnia Thursday, 7 of February 2008, Sam Ravnborg napisał:
> > On Thu, Feb 07, 2008 at 07:58:24AM -0500, Christoph Hellwig wrote:
> 
> > > Any chance to make arm finally use drivers/Kconfig?  It's a bit silly
> > > that arm still is crapping around while even s390 uses it.
> 
> > rmk said that it should be easy to check the amount of work needed to
> > do so. But I have not had time to look into it yet - hopefully someone
> > in ARM land could fix it.
> 
> I looked at it and 'arch/arm/Kconfig' does not source few entries: 

diff -u arch/arm/Kconfig drivers/Kconfig shows the situation.  This is
why I insist that new entries to arch/arm/Kconfig should be in the same
order as drivers/Kconfig.

> Including of 'drivers/mtd' depends on "ALIGNMENT_TRAP || !CPU_CP15_MMU".

It's this which is the main issue.

> Including of 'drivers/ide' depends on "PCMCIA || ARCH_CLPS7500 || 
> ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || ARCH_L7200 || 
> ARCH_LH7A40X || ARCH_PXA || ARCH_RPC || ARCH_S3C2410 || ARCH_SA1100 || 
> ARCH_SHARK || FOOTBRIDGE || ARCH_IXP23XX" but 'drivers/ata' (which can be 
> used instead on PCMCIA enabled platforms) does not depend on such set.

IDE people insisted that we _will_ have that silly conditional for IDE.
I personally do not want it and would be happy to see it go - but I
don't have the authority to do that.  Take this one up with Bart.
