Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYLNTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYLNTvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYLNTvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:51:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34253 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYLNTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:51:31 -0500
Date: Sun, 14 Dec 2008 19:51:16 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] remove linux/hardirq.h from asm-generic/local.h
Message-ID: <20081214195116.GB11223@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-arch@vger.kernel.org
References: <20081214133941.GA18035@flint.arm.linux.org.uk> <20081214095803.9d16e85f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214095803.9d16e85f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 09:58:03AM -0800, Andrew Morton wrote:
> On Sun, 14 Dec 2008 13:39:41 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > While looking at reducing the amount of architecture namespace pollution
> > in the generic kernel, I found that asm/irq.h is included in the vast
> > majority of compilations on ARM (around 650 files.)
> > 
> > Since asm/irq.h includes a sub-architecture include file on ARM, this
> > causes a negative impact on the ccache's ability to re-use the build
> > results from other sub-architectures, so we have a desire to reduce
> > the dependencies on asm/irq.h.
> > 
> > It turns out that a major cause of this is the needless include of
> > linux/hardirq.h into asm-generic/local.h.  The patch below removes this
> > include, resulting in some 250 to 300 files (around half) of the kernel
> > then omitting asm/irq.h.
> > 
> > My test builds still succeed, provided two ARM files are fixed
> > (arch/arm/kernel/traps.c and arch/arm/mm/fault.c) - so there may be
> > negative impacts for this on other architectures.
> > 
> > Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
> > asm/local.h, so this patch can be viewed as bringing the generic version
> > into line with the x86 version.
> 
> Sure.  Includes are easy to add and hard to remove.  I'll queue it up
> and see if there's fallout.

Thanks, I've committed to my git tree the addition of linux/hardirq.h to
those two files I mentioned above.  I guess at some point you'll pick
those up to prevent build errors on ARM?

> > From: Russell King <rmk+lkml@arm.linux.org.uk>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> that will result in the two rmk's getting separate akpm spam, different
> Author from Signer-offer, etc.  Adding an explicit From: line would
> improve things.

If they're sent as the same email, it doesn't matter.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
