Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXJXRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXJXRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXJXRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:37:28 -0400
Received: from mxout-04.mxes.net ([216.86.168.179]:1738 "EHLO
	mxout-04.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbXJXRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:37:27 -0400
Message-ID: <35146.86.7.220.119.1193247446.squirrel@wmbeta.mxes.net>
In-Reply-To: <20071024115857.GA21030@elte.hu>
References: <32892.86.7.220.119.1193222572.squirrel@wmbeta.mxes.net>
    <20071024115857.GA21030@elte.hu>
Date: Wed, 24 Oct 2007 18:37:26 +0100 (BST)
Subject: Re: [patch] natsemi: fix oops,
      link back netdevice from private-struct
From: "Andrew" <andrew@nelless.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Reply-To: "Andrew" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 24, 2007 12:58, Ingo Molnar wrote:
>
> the NULL dereference is here:
>
> (gdb) list *0xffffffff804a9504
> 0xffffffff804a9504 is in natsemi_poll (drivers/net/natsemi.c:717).
> 712             return count;
> 713     }
> 714
> 715     static inline void __iomem *ns_ioaddr(struct net_device *dev)
> 716     {
> 717             return (void __iomem *) dev->base_addr;
> 718     }
> 719
>
>
> which is this code from natsemi.c:
>
> 2227            struct net_device *dev = np->dev;
> 2228            void __iomem * ioaddr = ns_ioaddr(dev);
> 2229            int work_done = 0;
>
>
> seems like the NAPI changes in -rc1 added an np->dev field but forgot to initialize it ...
>
> does the patch below fix the oops for you?
>
> Ingo
>
>

Yep, that got it, thanks.

