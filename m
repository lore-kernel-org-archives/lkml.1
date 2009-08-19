Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZHSDLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZHSDLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZHSDLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:11:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59574
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbZHSDLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:11:48 -0400
Date: Tue, 18 Aug 2009 20:12:00 -0700 (PDT)
Message-Id: <20090818.201200.69809801.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: fix ks8851 build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090818152705.64557a0b.randy.dunlap@oracle.com>
References: <20090818184215.fdf1c7ae.sfr@canb.auug.org.au>
	<20090818152705.64557a0b.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 18 Aug 2009 15:27:05 -0700

> --- linux-next-20090818.orig/drivers/net/Kconfig
> +++ linux-next-20090818/drivers/net/Kconfig
> @@ -1733,6 +1733,8 @@ config KS8851
>         tristate "Micrel KS8851 SPI"
>         depends on SPI
>         select MII
> +	select CRC32
> +	select BITREVERSE
>         help
>           SPI driver for Micrel KS8851 SPI attached network chip.
>  

CRC32 alone is sufficient, because it, in turn, selects BITREVERSE

When you resubmit with this simplification, I'll apply the
patch to net-2.6 since the problem exists in Linus's tree
too, not just -next.
