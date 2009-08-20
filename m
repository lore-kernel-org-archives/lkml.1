Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZHTUwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZHTUwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZHTUwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:52:02 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56287 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZHTUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:52:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Date: Thu, 20 Aug 2009 13:51:50 -0700
From: Matheos Worku <Matheos.Worku@Sun.COM>
Subject: Re: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
In-reply-to: <200908202242.31778.PeterHuewe@gmx.de>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Jiri Kosina <trivial@kernel.org>, Alan Cox <alan@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-id: <4A8DB766.9020701@sun.com>
References: <200908202242.31778.PeterHuewe@gmx.de>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init macro to the module_init 
> function and all of its helper functions of char/vme_scc.c
>
> Alan or Geert, please have a look at the small patch and either pull it through 
> your tree, or please ack' it so Jiri can pull it through the trivial tree.
>
> linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
> index 994e1a5..8b24729 100644
> --- a/drivers/char/vme_scc.c
> +++ b/drivers/char/vme_scc.c
> @@ -136,7 +136,7 @@ static const struct tty_port_operations scc_port_ops = {
>   * vme_scc_init() and support functions
>   *---------------------------------------------------------------------------*/
>  
> -static int scc_init_drivers(void)
> +static int __init scc_init_drivers(void)
>  {
>  	int error;
>  
> @@ -172,7 +172,7 @@ static int scc_init_drivers(void)
>  /* ports[] array is indexed by line no (i.e. [0] for ttyS0, [1] for ttyS1).
>   */
>  
> -static void scc_init_portstructs(void)
> +static void __init scc_init_portstructs(void)
>  {
>  	struct scc_port *port;
>  	int i;
> @@ -195,7 +195,7 @@ static void scc_init_portstructs(void)
>  
>  
>  #ifdef CONFIG_MVME147_SCC
> -static int mvme147_scc_init(void)
> +static int __init mvme147_scc_init(void)
>  {
>  	struct scc_port *port;
>  	int error;
> @@ -298,7 +298,7 @@ fail:
>  
>  
>  #ifdef CONFIG_MVME162_SCC
> -static int mvme162_scc_init(void)
> +static int __init mvme162_scc_init(void)
>  {
>  	struct scc_port *port;
>  	int error;
> @@ -404,7 +404,7 @@ fail:
>  
>  
>  #ifdef CONFIG_BVME6000_SCC
> -static int bvme6000_scc_init(void)
> +static int __init bvme6000_scc_init(void)
>  {
>  	struct scc_port *port;
>  	int error;
> @@ -503,7 +503,7 @@ fail_free_b_rx:
>  #endif
>  
>  
> -static int vme_scc_init(void)
> +static int __init vme_scc_init(void)
>  {
>  	int res = -ENODEV;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Then there are issnvram.txt iss.conf etc ... I guess we need to change 
these as well.
How about error messages? I assume they would have ISS  in them.
Regards
Matheos
 
