Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXCWGbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXCWGbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXCWGbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:31:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:1851 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXCWGbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:31:06 -0400
X-IronPort-AV: i="4.14,317,1170651600"; 
   d="scan'208"; a="32238788:sNHT24518529"
Subject: Re: [PATCH -mm try#2] Blackfin: architecture update patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070323061232.GA27616@linux-sh.org>
References: <1174471618.5648.50.camel@roc-desktop>
	 <20070321125631.GA13192@linux-sh.org>
	 <1174629871.18866.22.camel@roc-desktop>
	 <20070323061232.GA27616@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 23 Mar 2007 14:31:13 +0800
Message-Id: <1174631473.18866.24.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 15:12 +0900, Paul Mundt wrote:
> On Fri, Mar 23, 2007 at 02:04:30PM +0800, Wu, Bryan wrote:
> > This is the latest blackfin update patch. Because there are lots of
> > issue fixing in this one, I put all modification in one update patch
> > which is located in:
> > https://blackfin.uclinux.org/gf/download/frsrelease/39/2707/blackfin-arch-2.6.21-rc4-mm1-update.patch
> > 
> I hope these will split up logically in the future so it's possible to
> reply to them without having to do manual mangling..
> 

>From now on, I will follow this rule. Thanks

> The patch generally looks fine, this is the only thing that really jumped
> out:
> 
> > Index: linux-2.6/include/asm-blackfin/pgtable.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-blackfin/pgtable.h
> > +++ linux-2.6/include/asm-blackfin/pgtable.h
> > @@ -59,4 +59,12 @@
> >  #define	VMALLOC_START	0
> >  #define	VMALLOC_END	0xffffffff
> >  
> > +#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
> > +#define arch_enter_lazy_cpu_mode()	do {} while (0)
> > +#define arch_leave_lazy_cpu_mode()	do {} while (0)
> > +
> > +#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> > +#define arch_enter_lazy_mmu_mode()	do {} while (0)
> > +#define arch_leave_lazy_mmu_mode()	do {} while (0)
> > +
> >  #endif				/* _BLACKFIN_PGTABLE_H */
> 
> asm-generic/pgtable.h already does this if you don't explicitly define
> __HAVE_ARCH_ENTER_LAZY_{CPU,MMU}_MODE. So please kill this entirely. If
> you forgot to include asm-generic/pgtable.h, that's another matter..

OK, I will check with this. Adding this dummy function is because
compiling will fail.

Best Regards,
-Bryan Wu
