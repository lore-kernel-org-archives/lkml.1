Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYJZPgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYJZPgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYJZPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:36:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27823 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYJZPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:36:45 -0400
Date: Sun, 26 Oct 2008 16:36:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: w83781d doesn't link when built-in
Message-ID: <20081026163624.622a0931@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0810261519410.15317@anakin>
References: <Pine.LNX.4.64.0810261519410.15317@anakin>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, 26 Oct 2008 15:20:26 +0100 (CET), Geert Uytterhoeven wrote:
> When w83781d is built-in, the final links fails with the following vague error
> message:
> 
> `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined
> in discarded section `.exit.text' of drivers/built-in.o
> 
> w83781d_isa_unregister() cannot be marked __exit, as it's also called from
> sensors_w83781d_init(), which is marked __init.

Good catch, thanks for reporting. For some reason the link doesn't fail
here.

> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/hwmon/w83781d.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/hwmon/w83781d.c
> +++ b/drivers/hwmon/w83781d.c
> @@ -1968,7 +1968,7 @@ exit:
>  	return res;
>  }
>  
> -static void __exit
> +static void
>  w83781d_isa_unregister(void)
>  {
>  	if (pdev) {
> @@ -2017,7 +2017,7 @@ w83781d_isa_register(void)
>  	return 0;
>  }
>  
> -static void __exit
> +static void
>  w83781d_isa_unregister(void)
>  {
>  }

Applied, thanks. I'll send this to Linus together with several other
hwmon patches later today.

-- 
Jean Delvare
