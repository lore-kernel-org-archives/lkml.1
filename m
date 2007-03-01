Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXCAJcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXCAJcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXCAJcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:32:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220AbXCAJcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:32:22 -0500
Date: Thu, 1 Mar 2007 01:32:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: nico@cam.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
 ethernet controller driver
Message-Id: <20070301013201.e43ae3f5.akpm@linux-foundation.org>
In-Reply-To: <1172741003.5264.88.camel@roc-desktop>
References: <1172722530.5264.78.camel@roc-desktop>
	<20070301005428.e5823f15.akpm@linux-foundation.org>
	<1172741003.5264.88.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 17:23:23 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> On Thu, 2007-03-01 at 00:54 -0800, Andrew Morton wrote:
> > On Thu, 01 Mar 2007 12:15:29 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> > 
> > > +/* check if the mac in reg is valid */
> > > +#define SMC_GET_MAC_ADDR(addr)					\
> > > +	do {							\
> > > +		unsigned int __v;				\
> > > +		__v = SMC_inw( ioaddr, ADDR0_REG );		\
> > > +		addr[0] = __v; addr[1] = __v >> 8;		\
> > > +		__v = SMC_inw( ioaddr, ADDR1_REG );		\
> > > +		addr[2] = __v; addr[3] = __v >> 8;		\
> > > +		__v = SMC_inw( ioaddr, ADDR2_REG );		\
> > > +		addr[4] = __v; addr[5] = __v >> 8;		\
> > > +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> > > +			random_ether_addr(addr);		\
> > > +		}						\
> > > +	} while (0)
> > 
> > Please follow kernel coding style:
> > 
> > 	__v = SMC_inw(ioaddr, ADDR2_REG);
> > 

You skipped this:

> > Can this not be implemented as a C function?

> +#define SMC_GET_MAC_ADDR(addr)					\
> +	do {							\
> +		unsigned int __v;				\
> +		__v = SMC_inw(ioaddr, ADDR0_REG);		\
> +		addr[0] = __v; addr[1] = __v >> 8;		\
> +		__v = SMC_inw(ioaddr, ADDR1_REG);		\
> +		addr[2] = __v; addr[3] = __v >> 8;		\
> +		__v = SMC_inw(ioaddr, ADDR2_REG);		\
> +		addr[4] = __v; addr[5] = __v >> 8;		\
> +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> +			random_ether_addr(addr);		\
> +		}						\
> +	} while (0)

It can be, I think...

Please always prefer coding in C over coding in cpp.
