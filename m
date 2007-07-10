Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXGJQzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXGJQzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXGJQym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:54:42 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:45450 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756833AbXGJQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:54:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aDXZ4pMMwM4eYlgiiA2SbGMJiYAMourTpw8/I3MKF6TYcJsrRtZMBhnJohc0U481Kc6tp/sWWLCOnUuuJ9lkFlQAstc2jIqy3iR6sto57yyg/+GIXLfiTfFPjV72ZfXHh+8TQGD6WEQ7kcFZHmhEEbaO4oe2LauTDMAiwpVoqdk=  ;
X-YMail-OSG: VIXocfoVM1maYN1Vn1biMSRnc0SRJIyVJCkuO.Q_VEFOOyB6JZHp6xJZYJ0PKzQoAYqq41YO7Q--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] spi.c:scan_boardinfo() mustn't be __init_or_module
Date: Tue, 10 Jul 2007 09:54:36 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070710124442.GV3492@stusta.de>
In-Reply-To: <20070710124442.GV3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707100954.37027.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007, Adrian Bunk wrote:
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
>   MODPOST vmlinux
> WARNING: drivers/built-in.o(.text+0x889735): Section mismatch: reference to .init.text:scan_boardinfo (between 'spi_register_master' and '__unregister')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
> --- linux-2.6.22-rc6-mm1/drivers/spi/spi.c.old	2007-07-10 04:17:26.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/spi/spi.c	2007-07-10 04:18:01.000000000 +0200
> @@ -302,8 +302,7 @@
>   * creates board info from kernel command lines
>   */
>  
> -static void __init_or_module
> -scan_boardinfo(struct spi_master *master)
> +static void scan_boardinfo(struct spi_master *master)
>  {
>  	struct boardinfo	*bi;
>  	struct device		*dev = master->cdev.dev;
> 


