Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXKKJhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXKKJhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 04:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbXKKJgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 04:36:54 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:46891 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753090AbXKKJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 04:36:53 -0500
Date: Sun, 11 Nov 2007 18:36:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Magnus Damm <damm@igel.co.jp>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       linuxsh-shmedia-dev@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: drivers/net/ax88796.c compile error on sh64
Message-ID: <20071111093625.GA25796@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Magnus Damm <damm@igel.co.jp>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net,
	linuxsh-shmedia-dev@lists.sourceforge.net, netdev@vger.kernel.org
References: <20071111090620.GK21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111090620.GK21669@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 10:06:21AM +0100, Adrian Bunk wrote:
> Commit 8687991a734a67f1638782c968f46fff0f94bb1f causes the following 
> compile error on sh64:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/net/ax88796.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c: In function 'ax_get_8390_hdr':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c:187: error: implicit declaration of function 'readsw'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c:189: error: implicit declaration of function 'readsb'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c: In function 'ax_block_output':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c:275: error: implicit declaration of function 'writesw'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ax88796.c:277: error: implicit declaration of function 'writesb'
> make[3]: *** [drivers/net/ax88796.o] Error 1
> 
> <--  snip -->
> 
That's a pretty good argument for the PLAT_HAS_xxx stuff in the Kconfig
space. We could have a if (CONFIG_SUPERH && !CONFIG_SUPERH64) thing here,
but there's probably not much point. I'm planning on merging them in the
2.6.25 time period anyways, so adding a stop-gap solution to hide this
driver's visibility doesn't really seem like a worthwhile endeavour.
