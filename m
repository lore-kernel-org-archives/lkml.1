Return-Path: <linux-kernel-owner+w=401wt.eu-S1945979AbXBIBHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945979AbXBIBHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945977AbXBIBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:07:30 -0500
Received: from mga05.intel.com ([192.55.52.89]:17374 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945948AbXBIBH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:07:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,303,1167638400"; 
   d="scan'208"; a="197649807:sNHT21378679"
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <3877989d0702080117j6ee666aahbb89ca0098ca38a5@mail.gmail.com>
References: <1170920422.15989.354.camel@ymzhang>
	 <3877989d0702080115o15feb447h73e3fa310bc09fb4@mail.gmail.com>
	 <3877989d0702080117j6ee666aahbb89ca0098ca38a5@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 09 Feb 2007 09:07:28 +0800
Message-Id: <1170983248.15989.356.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 17:17 +0800, Luming Yu wrote:
> sorry, it should be
> #define ATA_PRIMARY_IRQ(dev)  ide_default_irq(0x1F0)
> 
> On 2/8/07, Luming Yu <luming.yu@gmail.com> wrote:
> > if use ide_default_irq , then I guess the #if defined can be removed.
> > #define ATA_PRIMARY_IRQ(dev)   isa_irq_to_vector(0x1F0)
ata driver will replace old ide driver, so I don't use ide codes in
ata driver.

> >
> >
> > On 2/8/07, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> > > fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> > > to irq vector.
> > >
> > > Below patch against kernel 2.6.20 fixes it.
> > >
> > > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> > >
> > > ---
> > >
> > > diff -Nraup linux-2.6.20/include/asm-generic/libata-portmap.h linux-2.6.20_fix/include/asm-generic/libata-portmap.h
> > > --- linux-2.6.20/include/asm-generic/libata-portmap.h   2007-02-08 15:13:44.000000000 +0800
> > > +++ linux-2.6.20_fix/include/asm-generic/libata-portmap.h       2007-02-08 15:20:13.000000000 +0800
> > > @@ -3,10 +3,20 @@
> > >
> > >  #define ATA_PRIMARY_CMD                0x1F0
> > >  #define ATA_PRIMARY_CTL                0x3F6
> > > +#if defined(__ia64__)
> > > +#define ATA_PRIMARY_IRQ(dev)   isa_irq_to_vector(14)
> > > +#else
> > >  #define ATA_PRIMARY_IRQ(dev)   14
> > > +#endif
> > > +
> > >
> > >  #define ATA_SECONDARY_CMD      0x170
> > >  #define ATA_SECONDARY_CTL      0x376
> > > +#if defined(__ia64__)
> > > +#define ATA_SECONDARY_IRQ(dev) isa_irq_to_vector(15)
> > > +#else
> > >  #define ATA_SECONDARY_IRQ(dev) 15
> > > +#endif
> > > +
> > >
> > >  #endif
