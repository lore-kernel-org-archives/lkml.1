Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXCAKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXCAKQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964869AbXCAKQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:16:41 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:48921 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbXCAKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:16:39 -0500
X-IronPort-AV: i="4.14,234,1170651600"; 
   d="scan'208"; a="23223978:sNHT23783921"
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
	ethernet controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, nico@cam.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070301020330.2480699a.akpm@linux-foundation.org>
References: <1172722530.5264.78.camel@roc-desktop>
	 <20070301005428.e5823f15.akpm@linux-foundation.org>
	 <1172741003.5264.88.camel@roc-desktop>
	 <20070301013201.e43ae3f5.akpm@linux-foundation.org>
	 <1172742768.5264.97.camel@roc-desktop>
	 <20070301020330.2480699a.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 01 Mar 2007 18:16:02 +0800
Message-Id: <1172744162.5264.102.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 02:03 -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 17:52:48 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > > Please always prefer coding in C over coding in cpp.
> > 
> > Yes, it can be writen as a C function.
> > We just follow other implementation in the drivers/net/smc91x.h
> > 
> > start at line 1156 of
> > ---
> > #ifndef SMC_GET_MAC_ADDR
> > #define SMC_GET_MAC_ADDR(addr)                                          \
> >         do {                                                            \
> >                 unsigned int __v;                                       \
> >                 __v = SMC_inw( ioaddr, ADDR0_REG );                     \
> >                 addr[0] = __v; addr[1] = __v >> 8;                      \
> >                 __v = SMC_inw( ioaddr, ADDR1_REG );                     \
> >                 addr[2] = __v; addr[3] = __v >> 8;                      \
> >                 __v = SMC_inw( ioaddr, ADDR2_REG );                     \
> >                 addr[4] = __v; addr[5] = __v >> 8;                      \
> >         } while (0)
> > #endif
> > _
> 
> Please don't treat ghastly old driver code as a model for new kernel code.
> 
> > If you think this is necessary, we may rewrite it in C function.
> 
> hm, well, if it's copied and pasted from somewhere else then there is some
> merit in leaving it as it is.
> 
> It would of course be better to pull it out into a shared header file, avoid the
> duplication.

Exactly, this is a better solution. Because smc91x driver is widely used
in embedded linux world, we just want to add our arch support into this
common driver.

Maybe Nico can help us on this.

Thanks
-Bryan Wu 
