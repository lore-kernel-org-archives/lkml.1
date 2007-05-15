Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbXEOHgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbXEOHgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXEOHgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:36:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:49247 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbXEOHgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:36:07 -0400
Subject: Re: [PATCH v2] pcmcia: ppc64 needs 32-bit ioaddr_t
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070515043343.GA6561@lixom.net>
References: <20070512143105.GA12890@lixom.net>
	 <20070515043343.GA6561@lixom.net>
Content-Type: text/plain
Date: Tue, 15 May 2007 17:35:05 +1000
Message-Id: <1179214505.32247.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 23:33 -0500, Olof Johansson wrote:
> ppc64 really needs ioaddr_t to be 32-bit, since I/O beyond the
> first PCI bus might be mapped at a higher range.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users. Besides, those interfaces are overdue for removal
> already.
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Index: 2.6.21/include/pcmcia/cs_types.h
> ===================================================================
> --- 2.6.21.orig/include/pcmcia/cs_types.h
> +++ 2.6.21/include/pcmcia/cs_types.h
> @@ -21,7 +21,7 @@
>  #include <sys/types.h>
>  #endif
>  
> -#if defined(__arm__) || defined(__mips__)
> +#if defined(__arm__) || defined(__mips__) || defined(__powerpc64__)
>  /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
>  typedef u_int   ioaddr_t;
>  #else
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

