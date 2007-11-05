Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXKEQUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXKEQUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXKEQTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:19:53 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:36484 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbXKEQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:19:52 -0500
Message-ID: <472F4298.60005@freescale.com>
Date: Mon, 05 Nov 2007 10:19:36 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] [POWERPC] Fix fs_enet module build
References: <472CDE02.1020804@scram.de>
In-Reply-To: <472CDE02.1020804@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> diff --git a/drivers/net/fs_enet/Makefile b/drivers/net/fs_enet/Makefile
> index 02d4dc1..2f7563a 100644
> --- a/drivers/net/fs_enet/Makefile
> +++ b/drivers/net/fs_enet/Makefile
> @@ -4,7 +4,15 @@
> 
> obj-$(CONFIG_FS_ENET) += fs_enet.o
> 
> -obj-$(CONFIG_8xx) += mac-fec.o mac-scc.o mii-fec.o
> -obj-$(CONFIG_CPM2) += mac-fcc.o mii-bitbang.o
> +fs_enet-$(CONFIG_8xx) += mac-fec.o mac-scc.o
> +fs_enet-$(CONFIG_CPM2) += mac-fcc.o
> +
> +ifeq ($(CONFIG_8xx),y)
> +        obj-$(CONFIG_FS_ENET) += mii-fec.o
> +endif
> +
> +ifeq ($(CONFIG_CPM2),y)
> +        obj-$(CONFIG_FS_ENET) += mii-bitbang.o
> +endif
> 
> fs_enet-objs := fs_enet-main.o

If we're going to mess with this, we should probably just make 
CONFIG_FS_ENET_SCC, CONFIG_FS_ENET_FCC, and CONFIG_FS_ENET_FEC, and have 
them depend on CONFIG_FS_ENET.

-Scott
