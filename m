Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXCAJx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXCAJx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964785AbXCAJx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:53:27 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:8445 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXCAJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:53:26 -0500
X-IronPort-AV: i="4.14,234,1170651600"; 
   d="scan'208"; a="23222380:sNHT24639048"
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
	ethernet controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, nico@cam.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070301013201.e43ae3f5.akpm@linux-foundation.org>
References: <1172722530.5264.78.camel@roc-desktop>
	 <20070301005428.e5823f15.akpm@linux-foundation.org>
	 <1172741003.5264.88.camel@roc-desktop>
	 <20070301013201.e43ae3f5.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 01 Mar 2007 17:52:48 +0800
Message-Id: <1172742768.5264.97.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 01:32 -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 17:23:23 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > On Thu, 2007-03-01 at 00:54 -0800, Andrew Morton wrote:
> > > On Thu, 01 Mar 2007 12:15:29 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> > > 
> > > > +/* check if the mac in reg is valid */
> > > > +#define SMC_GET_MAC_ADDR(addr)					\
> > > > +	do {							\
> > > > +		unsigned int __v;				\
> > > > +		__v = SMC_inw( ioaddr, ADDR0_REG );		\
> > > > +		addr[0] = __v; addr[1] = __v >> 8;		\
> > > > +		__v = SMC_inw( ioaddr, ADDR1_REG );		\
> > > > +		addr[2] = __v; addr[3] = __v >> 8;		\
> > > > +		__v = SMC_inw( ioaddr, ADDR2_REG );		\
> > > > +		addr[4] = __v; addr[5] = __v >> 8;		\
> > > > +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> > > > +			random_ether_addr(addr);		\
> > > > +		}						\
> > > > +	} while (0)
> > > 
> > > Please follow kernel coding style:
> > > 
> > > 	__v = SMC_inw(ioaddr, ADDR2_REG);
> > > 
> 
> You skipped this:
> 
> > > Can this not be implemented as a C function?
> 
> > +#define SMC_GET_MAC_ADDR(addr)					\
> > +	do {							\
> > +		unsigned int __v;				\
> > +		__v = SMC_inw(ioaddr, ADDR0_REG);		\
> > +		addr[0] = __v; addr[1] = __v >> 8;		\
> > +		__v = SMC_inw(ioaddr, ADDR1_REG);		\
> > +		addr[2] = __v; addr[3] = __v >> 8;		\
> > +		__v = SMC_inw(ioaddr, ADDR2_REG);		\
> > +		addr[4] = __v; addr[5] = __v >> 8;		\
> > +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> > +			random_ether_addr(addr);		\
> > +		}						\
> > +	} while (0)
> 
> It can be, I think...
> 
> Please always prefer coding in C over coding in cpp.

Yes, it can be writen as a C function.
We just follow other implementation in the drivers/net/smc91x.h

start at line 1156 of
---
#ifndef SMC_GET_MAC_ADDR
#define SMC_GET_MAC_ADDR(addr)                                          \
        do {                                                            \
                unsigned int __v;                                       \
                __v = SMC_inw( ioaddr, ADDR0_REG );                     \
                addr[0] = __v; addr[1] = __v >> 8;                      \
                __v = SMC_inw( ioaddr, ADDR1_REG );                     \
                addr[2] = __v; addr[3] = __v >> 8;                      \
                __v = SMC_inw( ioaddr, ADDR2_REG );                     \
                addr[4] = __v; addr[5] = __v >> 8;                      \
        } while (0)
#endif
_

If you think this is necessary, we may rewrite it in C function.

Thanks
-Bryan
