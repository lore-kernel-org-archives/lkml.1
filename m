Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbYD0WpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbYD0WpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYD0Woy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:44:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYD0Woy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:44:54 -0400
Message-ID: <481501CC.2040408@zytor.com>
Date: Sun, 27 Apr 2008 15:44:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <1209329485.3801.46.camel@localhost.localdomain>	 <20080427214837.GA11631@elte.hu> <1209335660.3801.79.camel@localhost.localdomain> <4815009C.2010809@garzik.org>
In-Reply-To: <4815009C.2010809@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Isn't there Yet More Breakage in lib/iomap.c, given these new semantics?
> 
>         if (flags & IORESOURCE_MEM) {
>                 if (flags & IORESOURCE_CACHEABLE)
>                         return ioremap(start, len);
>                 return ioremap_nocache(start, len);
>         }
> 
> Any driver using pci_iomap() (libata, and others) is affected.
> 
> I disagree with this semantics change.  A number of code places _and 
> drivers_ GET IT RIGHT, and these are all broken now?
> 

They don't, though.  They rely on the MTRRs to get it right for them, 
and the MTRRs will say "uncached" in nearly all cases.

Consider the case above: you would have gotten the same result 
*regardless*, because the MTRRs would not have made the memory 
cacheable.  Yes, it's broken, but it was broken before as well.

	-hpa
