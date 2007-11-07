Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXKGWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXKGWFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXKGWFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:05:32 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:40091 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110AbXKGWFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:05:31 -0500
Date: Wed, 7 Nov 2007 23:04:55 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards
Message-ID: <20071107220455.GA15367@electric-eye.fr.zoreil.com>
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4731FDB7.8010505@rtr.ca>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> :
> Fix r8169 regression on ASUS motherboards.
> 
> The r8169 ethernet driver worked fine in 2.6.23, but fails
> in 2.6.24-rc* for the onboard ethernet of ASUS P5B series motherboards.
> This patch fixes it again.
[...]
> --- broken/drivers/net/r8169.c	2007-11-07 12:32:29.000000000 -0500
> +++ linux/drivers/net/r8169.c	2007-11-07 12:55:07.000000000 -0500
> @@ -1325,6 +1325,7 @@
> 		rtl8169sb_hw_phy_config(ioaddr);
> 		break;
> 	case RTL_GIGA_MAC_VER_11:
> +		break;
> 	case RTL_GIGA_MAC_VER_12:
> 	case RTL_GIGA_MAC_VER_17:
> 		rtl8168b_hw_phy_config(ioaddr);

I am not convinced, the broken ones include some RTL_GIGA_MAC_VER_12
too, namely XID = 0x38000000.

I would much prefer to revert the broken commit completely (which I am
currently isolating).


-- 
Ueimor
