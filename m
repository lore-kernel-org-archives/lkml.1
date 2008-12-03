Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYLCUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYLCUUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYLCT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:56:27 -0500
Received: from mail.vyatta.com ([76.74.103.46]:57172 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbYLCT4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:56:25 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.394
Date: Wed, 3 Dec 2008 11:56:22 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: m68k 8390 breakage (was: Re: linux-next: Tree for December 3)
Message-ID: <20081203115622.50256091@extreme>
In-Reply-To: <Pine.LNX.4.64.0812032042480.10635@anakin>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0812032042480.10635@anakin>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 20:49:39 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Wed, 3 Dec 2008, Stephen Rothwell wrote:
> > Status of my local build tests will be at
> > http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> Since a few days, m68k defconfig and allmodconfig give:
> 
> | drivers/net/lib8390.c:1014: undefined reference to `ei_start_xmit'
> | drivers/net/lib8390.c:1015: undefined reference to `ei_get_stats'
> | drivers/net/lib8390.c:1016: undefined reference to `ei_set_multicast_list'
> 
> (cfr. e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/58795/)
> 
> git bisect run on "make ARCH=m68k mac_defconfig vmlinux" tells me:
> 
> 8884c092e5e4f9a1b6e44f2e02a3eb5481af87ab is first bad commit
> commit 8884c092e5e4f9a1b6e44f2e02a3eb5481af87ab
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Tue Nov 25 18:12:49 2008 -0800
> 
>     8390: add common net_device ops
> 
>     Fix the defactoring of ei_XXX functions in 8390 and 8390p.
>     Remove the tx_timeout hack since no driver including the 3c503
>     overrides tx_timeout at this time, looks like a legacy thing.
> 
>     Also, since several drivers all have same hooks, provide common
>     netdev_ops.
> 
>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
	

Which driver is having problem
