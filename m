Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZEZLXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZEZLXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZEZLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:22:54 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52868 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZEZLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:22:54 -0400
Date: Tue, 26 May 2009 20:22:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>, rtc-linux@googlegroups.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] drivers/char/rtc: disable legacy RTC driver on Blackfin systems
Message-ID: <20090526112240.GA16835@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, rtc-linux@googlegroups.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <1243332633-15258-1-git-send-email-vapier@gentoo.org> <20090526102502.GA24737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526102502.GA24737@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 06:25:02AM -0400, Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 06:10:33AM -0400, Mike Frysinger wrote:
> >  	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
> >  	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
> > -			&& !ARM && !SUPERH && !S390 && !AVR32
> > +			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
> 
> Maybe it's better to have a positive dependency for those that actually
> support it these days?  Based on the above list that would be:
> 
> 	depends on ALPHA || CRIS || H8300 || M32R || MICROBLAZE ||
> 		   MIPS || MN10300 || SH || X86 || XTENSA
> 
> and I would not be surprised if some of the above don't actually support
> it either..

SH shouldn't be included it, we've never supported it. Out of the ones
that do support this interface, I would guess that they should require
little to no modification to work with drivers/rtc/rtc-cmos.c.

Out of the ones that don't actually support this interface but never
bothered updating the Kconfig bits.. none of h8300/microblaze/xtensa
define any of the CMOS_READ/WRITE() accessors, so this has no chance at
all of working there.

Now to narrow that list down a bit more, both m32r and cris primarily use
this interface for their ds1302 RTC, which I added a stub driver for in
drivers/rtc/rtc-ds1302.c some time ago. With a bit of cleanup on the
driver side and a bit of a push from the architecture side, they should
also be able to just use the drivers/rtc version directly. I've offered
to help with the conversion for these platforms before, but neither
maintainer seemed terribly responsive.

Which basically leaves just alpha, mips, mn10300, and x86. I would be
surprised if these don't work with rtc-cmos already today.
