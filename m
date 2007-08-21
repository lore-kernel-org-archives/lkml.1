Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXHUR4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXHUR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbXHURzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:55:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44480 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbXHURzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:55:54 -0400
Date: Tue, 21 Aug 2007 18:54:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821175453.GB19819@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821173550.GC30705@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:35:50PM +0200, Adrian Bunk wrote:
> On Tue, Aug 21, 2007 at 09:31:03AM -0700, Randy Dunlap wrote:
> > On Tue, 21 Aug 2007 15:20:38 +0200 Jarek Poplawski wrote:
> > 
> > > Here are some more of, probably well-known, warnings with attached
> > > testing-only .config.
> > >...
> > > drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
> > > drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
> > > drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
> > >...
> > 
> > What gcc version?  I don't get the arch_ warnings in drivers/pci/msi.c.
> 
> Obviously a gcc <= 3.4 [1], and therefore no unit-at-a-time.
> 
> You can reproduce it with a more recent gcc when adding 
> -fno-unit-at-a-time to the CFLAGS.
> 
> And it's becoming a real maintainance problem that not only this problem 
> but also other problems like some section mismatches [2] are only 
> present without unit-at-a-time.
> 
> Currently we support 6 different stable gcc release series, and it might 
> be the right time to consider dropping support for the older ones.
> 
> Are there any architectures still requiring a gcc < 4.0 ?

I want to keep support for gcc 3.4.3 for ARM for the forseeable future.
>From my point of view, gcc 4 compilers have been something of a development
thing as far as the ARM architecture goes.  Also, gcc 3.4.3 is faster and
significantly less noisy than gcc 4.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
