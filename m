Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364Ab0AKIB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0AKIB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240Ab0AKIB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:01:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56820
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152Ab0AKIB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:01:56 -0500
Date: Mon, 11 Jan 2010 00:02:05 -0800 (PST)
Message-Id: <20100111.000205.164473435.davem@davemloft.net>
To: Stephen@Rothwell.id.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>
References: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <Stephen@Rothwell.id.au>
Date: Mon, 11 Jan 2010 18:42:05 +1100

> Hi all,
> 
> Today's linux-next build (powerpc_allnoconfig) failed like this:
> 
> lib/lib.a(vsprintf.o): In function `pointer':
> vsprintf.c:(.text+0x21ba): undefined reference to `byte_rev_table'
> vsprintf.c:(.text+0x21c2): undefined reference to `byte_rev_table'
> 
> Caused by commit bc7259a2ce764ea16200eb9e53f6e136e918d065
> ("lib/vsprintf.c: Add %pMF to format FDDI bit reversed MAC addresses")
> from the net tree.
> 
> I applied the following fixup patch (and can carry it for a while):
> (BTW after this patch, CONFIG_BITREVERSE appears to not be used anywhere
> except where is is selected in Kconfig files.)
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 11 Jan 2010 18:37:16 +1100
> Subject: [PATCH] net: vsprintf now depends on the byte_rev_table
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks I'll apply this and then add a commit which kills
off CONFIG_BITREVERSE.

Thanks!
