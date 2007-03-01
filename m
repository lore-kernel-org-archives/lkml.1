Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXCAKDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXCAKDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964808AbXCAKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:03:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964807AbXCAKDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:03:52 -0500
Date: Thu, 1 Mar 2007 02:03:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: nico@cam.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
 ethernet controller driver
Message-Id: <20070301020330.2480699a.akpm@linux-foundation.org>
In-Reply-To: <1172742768.5264.97.camel@roc-desktop>
References: <1172722530.5264.78.camel@roc-desktop>
	<20070301005428.e5823f15.akpm@linux-foundation.org>
	<1172741003.5264.88.camel@roc-desktop>
	<20070301013201.e43ae3f5.akpm@linux-foundation.org>
	<1172742768.5264.97.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 17:52:48 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> > Please always prefer coding in C over coding in cpp.
> 
> Yes, it can be writen as a C function.
> We just follow other implementation in the drivers/net/smc91x.h
> 
> start at line 1156 of
> ---
> #ifndef SMC_GET_MAC_ADDR
> #define SMC_GET_MAC_ADDR(addr)                                          \
>         do {                                                            \
>                 unsigned int __v;                                       \
>                 __v = SMC_inw( ioaddr, ADDR0_REG );                     \
>                 addr[0] = __v; addr[1] = __v >> 8;                      \
>                 __v = SMC_inw( ioaddr, ADDR1_REG );                     \
>                 addr[2] = __v; addr[3] = __v >> 8;                      \
>                 __v = SMC_inw( ioaddr, ADDR2_REG );                     \
>                 addr[4] = __v; addr[5] = __v >> 8;                      \
>         } while (0)
> #endif
> _

Please don't treat ghastly old driver code as a model for new kernel code.

> If you think this is necessary, we may rewrite it in C function.

hm, well, if it's copied and pasted from somewhere else then there is some
merit in leaving it as it is.

It would of course be better to pull it out into a shared header file, avoid the
duplication.
