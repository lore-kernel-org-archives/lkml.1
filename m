Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXCAIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXCAIy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXCAIy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:54:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbXCAIyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:54:55 -0500
Date: Thu, 1 Mar 2007 00:54:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: nico@cam.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
 ethernet controller driver
Message-Id: <20070301005428.e5823f15.akpm@linux-foundation.org>
In-Reply-To: <1172722530.5264.78.camel@roc-desktop>
References: <1172722530.5264.78.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 12:15:29 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> +/* check if the mac in reg is valid */
> +#define SMC_GET_MAC_ADDR(addr)					\
> +	do {							\
> +		unsigned int __v;				\
> +		__v = SMC_inw( ioaddr, ADDR0_REG );		\
> +		addr[0] = __v; addr[1] = __v >> 8;		\
> +		__v = SMC_inw( ioaddr, ADDR1_REG );		\
> +		addr[2] = __v; addr[3] = __v >> 8;		\
> +		__v = SMC_inw( ioaddr, ADDR2_REG );		\
> +		addr[4] = __v; addr[5] = __v >> 8;		\
> +		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
> +			random_ether_addr(addr);		\
> +		}						\
> +	} while (0)

Please follow kernel coding style:

	__v = SMC_inw(ioaddr, ADDR2_REG);


Can this not be implemented as a C function?
