Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYFIJd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYFIJd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbYFIJdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:33:20 -0400
Received: from 25.mail-out.ovh.net ([91.121.27.228]:50704 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752948AbYFIJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:33:19 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 05:33:18 EDT
To: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: [patch, v2.6.26-rc5] net/irda build fix: mcs7780
MIME-Version: 1.0
Date: Mon, 09 Jun 2008 11:26:37 +0200
From: <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080609082257.GA15282@elte.hu>
References: <20080604.170123.234927220.davem@davemloft.net> <20080609082257.GA15282@elte.hu>
Message-ID: <47304c8330b37ab2677d72f8c8adbe12@localhost>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17826091751503407127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Jun 2008 10:22:57 +0200, Ingo Molnar <mingo@elte.hu> wrote:
> 
> -tip testing found the following build error:
> 
>   drivers/built-in.o: In function `mcs_receive_irq':
>   mcs7780.c:(.text+0x4e429): undefined reference to `crc32_le'
>   drivers/built-in.o: In function `mcs_hard_xmit':
>   mcs7780.c:(.text+0x4e9af): undefined reference to `crc32_le'
> 
> with:
> 
>   http://redhat.com/~mingo/misc/config-Sun_Jun__8_22_56_14_CEST_2008.bad
> 
> the reason is a missing enablement of the CRC32 library in the Kconfig.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
Many thanks Ingo.

Dave, I can take it with my next IrDA patch set. But since it's a build
failure, you may want to take it immediatly, it's up to you.
In the latter case:

Signed-off-by: Samuel Ortiz <samuel@sortiz.org>

> ---
>  drivers/net/irda/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/drivers/net/irda/Kconfig
> ===================================================================
> --- linux.orig/drivers/net/irda/Kconfig
> +++ linux/drivers/net/irda/Kconfig
> @@ -329,6 +329,7 @@ config PXA_FICP
>  config MCS_FIR
>  	tristate "MosChip MCS7780 IrDA-USB dongle"
>  	depends on IRDA && USB && EXPERIMENTAL
> +	select CRC32
>  	help
>  	  Say Y or M here if you want to build support for the MosChip
>  	  MCS7780 IrDA-USB bridge device driver.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

