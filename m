Return-Path: <linux-kernel-owner+w=401wt.eu-S946092AbXHMQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946092AbXHMQyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948353AbXHMQ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:27:02 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56860 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948349AbXHMQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:26:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 11:24:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Surya Prabhakar N <surya.prabhakar@wipro.com>
cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] replacing kmalloc with kzalloc in drivers/net/sb1250-mac.c
In-Reply-To: <1186999123.29518.18.camel@bluegenie>
Message-ID: <Pine.LNX.4.64.0708131123020.2277@localhost.localdomain>
References: <1186999123.29518.18.camel@bluegenie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.541, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Z 0.26)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Surya Prabhakar N wrote:

> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in
> drivers/net/sb1250-mac.c
>
>
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> ---
>
> diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
> index e7fdcf1..2dca5a7 100644
> --- a/drivers/net/sb1250-mac.c
> +++ b/drivers/net/sb1250-mac.c
> @@ -760,7 +760,7 @@ static void sbdma_initctx(sbmacdma_t *d,
>
>  	d->sbdma_dscrtable_unaligned =
>  	d->sbdma_dscrtable = (sbdmadscr_t *)
                             ^^^^^^^^^^^^^^^
> -		kmalloc((d->sbdma_maxdescr+1)*sizeof(sbdmadscr_t), GFP_KERNEL);
> +		kzalloc((d->sbdma_maxdescr+1)*sizeof(sbdmadscr_t), GFP_KERNEL);

i'm fairly sure you can drop all of those superfluous casts when
calling one of those memory allocation routines.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
