Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbXEKRE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbXEKRE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXEKREw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:04:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4150 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXEKREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:04:51 -0400
Date: Fri, 11 May 2007 18:04:43 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make csum_and_copy_from_user arch independent
Message-ID: <20070511170443.GF26112@flint.arm.linux.org.uk>
Mail-Followup-To: Frederik Deweerdt <deweerdt@free.fr>,
	David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070509012322.199f292b.akpm@linux-foundation.org> <20070511082738.GA23560@slug> <20070511.021443.41636409.davem@davemloft.net> <20070511135618.GE23638@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511135618.GE23638@slug>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 03:56:18PM +0200, Frederik Deweerdt wrote:
> On Fri, May 11, 2007 at 02:14:43AM -0700, David Miller wrote:
> > From: Frederik Deweerdt <deweerdt@free.fr>
> > Date: Fri, 11 May 2007 10:27:38 +0200
> > 
> > > ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
> > > 
> > > Linking on ARM fails because albeit a generic csum_and_copy_from_user()
> > > function is provided in the case ! _HAVE_ARCH_COPY_AND_CSUM_FROM_USER, the
> > > generic function uses csum_partial_copy_from_user() which is i386 only.
> > 
> > On what planet is csum_partial_copy_from_user() i386 only?
> > Every single platform provides that function.
> Er, my bad, I've changed my cscope bindings and I saw no results except
> i386.
> > The issue more-so appears to be that ARM simply fails to
> > export the symbol to modules like the other platforms do.
> Indeed, here's the fix.

Could you mail it to me in the conventional format (iow, with a
proper subject line and description) please?

> Thanks,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index 4779f47..9179e82 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -76,6 +76,7 @@ EXPORT_SYMBOL(__const_udelay);
>  
>  	/* networking */
>  EXPORT_SYMBOL(csum_partial);
> +EXPORT_SYMBOL(csum_partial_copy_from_user);
>  EXPORT_SYMBOL(csum_partial_copy_nocheck);
>  EXPORT_SYMBOL(__csum_ipv6_magic);
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
