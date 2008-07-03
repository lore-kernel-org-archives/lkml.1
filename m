Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYGCMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYGCMj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYGCMjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:39:14 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:5294 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbYGCMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DcP+mreNVzKjxmKQ2X+FBOh0/qA5It7dZZtEyylK/IopS2byIy2KVtG1GZBCq+S0xB
         O0NH4qWEp231+cB/UtK9BXO7hDp/tcKQ7hMTXd1urZq6Y7wee/kpTU5DGzHt1xvzndRk
         B/LY2n4Fk/hLwBJceRYRltSckni7vnm3/Qijc=
Date: Thu, 3 Jul 2008 08:38:28 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: inux-next 0701 mv643xx_eth powerpc build failure
Message-ID: <20080703123828.GA1631@nineveh.local>
Mail-Followup-To: Lennert Buytenhek <buytenh@wantstofly.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au> <20080702031111.GA26752@nineveh.local> <20080702082117.GA18989@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702082117.GA18989@xi.wantstofly.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 10:21:18AM +0200, Lennert Buytenhek wrote:
> On Tue, Jul 01, 2008 at 11:11:12PM -0400, Joseph Fannin wrote:
>
> > I'm getting a build failure on 32bit powerpc in -next, but not in mainline:
> >
> > drivers/net/mv643xx_eth.c: In function 'mv643xx_eth_netpoll':
> > drivers/net/mv643xx_eth.c:2115: error: 'INT_CAUSE_EXT' undeclared
> > (first use in this function)
> > drivers/net/mv643xx_eth.c:2115: error: (Each undeclared identifier is
> > reported only once
> > drivers/net/mv643xx_eth.c:2115: error: for each function it appears in.)
>
> Does this fix it for you?

  Yes, it builds fine.  Thanks.

>
> Index: linux-2.6.26-rc8/drivers/net/mv643xx_eth.c
> ===================================================================
> --- linux-2.6.26-rc8.orig/drivers/net/mv643xx_eth.c
> +++ linux-2.6.26-rc8/drivers/net/mv643xx_eth.c
> @@ -2184,7 +2184,7 @@ static void mv643xx_eth_netpoll(struct n
>
>  	mv643xx_eth_irq(dev->irq, dev);
>
> -	wrl(mp, INT_MASK(mp->port_num), INT_TX_END | INT_RX | INT_CAUSE_EXT);
> +	wrl(mp, INT_MASK(mp->port_num), INT_TX_END | INT_RX | INT_EXT);
>  }
>  #endif
>
>
>
> > I haven't investigated any further than a quick check if this hardware
> > even makes sense on 32bit powerpc -- it seems it does.
>
> It does -- it is used on ARM, PPC and MIPS.

--
Joseph Fannin
jfannin@gmail.com

