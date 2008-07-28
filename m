Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYG1WjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYG1WjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG1Wi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:38:58 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:63603 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751423AbYG1Wi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:38:57 -0400
Date: Mon, 28 Jul 2008 23:38:28 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: lethal@linux-sh.org, Yusuke Goda <goda.yusuke@renesas.com>,
       Magnus Damm <damm@igel.co.jp>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] SH_AP325RXA must select I2C
Message-ID: <20080728223828.GF8301@fluff.org.uk>
References: <20080728201705.GC7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728201705.GC7713@cs181140183.pp.htv.fi>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:17:05PM +0300, Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   LD      vmlinux
> arch/sh/boards/renesas/ap325rxa/built-in.o: In function `camera_set_capture':
> setup.c:(.text+0x80): undefined reference to `i2c_get_adapter'
> setup.c:(.text+0x88): undefined reference to `i2c_transfer'
> make[1]: *** [vmlinux] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I suggest fixing the code or moving out to something that
depends on having I2C available.
 
> ---
> cdcb22706c51f0ae44946f4c3826cc3658960eba 
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 7bfb0d2..6f77d0a 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -520,6 +520,7 @@ config SH_MIGOR
>  config SH_AP325RXA
>  	bool "AP-325RXA"
>  	depends on CPU_SUBTYPE_SH7723
> +	select I2C
>  	help
>  	  Renesas "AP-325RXA" support.
>  	  Compatible with ALGO SYSTEM CO.,LTD. "AP-320A"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
