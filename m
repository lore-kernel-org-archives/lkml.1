Return-Path: <linux-kernel-owner+w=401wt.eu-S1945967AbXC3J5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967AbXC3J5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945964AbXC3J5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:57:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47508 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945967AbXC3J5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:57:13 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 30 Mar 2007 05:55:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Glauber <jang@linux.vnet.ibm.com>
cc: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org
Subject: Re: Why is arch/s390/crypto/Kconfig sourced when building for another
 arch ?
In-Reply-To: <1175247012.5474.15.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703300551460.10946@CPE00045a9c397f-CM001225dbafb6>
References: <eueg41$j5t$1@sea.gmane.org> <1175247012.5474.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Jan Glauber wrote:

> Hi Thomas,
>
> > with 2.6.20.4 it works great, but when switching to 2.6.21-rcX it breaks
> > with this:
> >
> > drivers/crypto/Kconfig:55: can't open file "arch/s390/crypto/Kconfig"
>
> arch/s390/crypto/Kconfig is included there since that is the right place
> for the config options to show up.
>
> > I tried to fix drivers/crypto/Kconfig by changing the code to:
> >
> > if S390
> > source "arch/s390/crypto/Kconfig"
> > endif
> >
> > but it still gets sourced...
>
> You would need something like:
>
> source "arch/s390/crypto/Kconfig"
> 	depends on S390
>
> But that is not implemented and I doubt it will since deleting parts
> of the kernel tree is not something that is required to work.

  i would think the obvious solution is to move the entire contents of
the s390-specific crypto/Kconfig into the generic one.  obviously,
everything would still work since all of those config options would
still depend on S390.

  i'm betting the S390 folks would *really* hate that idea but, if you
look closely, the generic Kconfig file *already* has some
arch-dependent content:

...
config CRYPTO_DEV_PADLOCK
        tristate "Support for VIA PadLock ACE"
        depends on X86_32     <-----
...

  i think it's a matter of deciding how to be consistent.  either you
allow individual architectures to define their own additional Kconfig
files or you don't.  mixing the two approaches is a recipe for
confusion.

rday


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
